using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using TestAPI.Models.Auth;
using TestAPI.Services.Email;
using TestAPI.Services.HubService;
using TestAPI.Services.Token;
using TestAPI.Services;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using System.Net;
using Azure.Core;
using System.Security.Policy;
using TestAPI.Controllers.Auth;


namespace TestAPI.Repository.AuthRepo
{
    public class AuthRepository : IAuthRepository
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly IAuthService _authService;
        private readonly IEmailService _emailService;
        private readonly IOTPService _otpService;
        private readonly ITokenService _tokenService;
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly IHubContext<ServiceHub> _hubContext;
        private readonly IUrlHelper _urlHelper;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public AuthRepository(UserManager<IdentityUser> userManager, RoleManager<IdentityRole> roleManager, IAuthService authService, IEmailService emailService, IOTPService otpService, ITokenService tokenService, SignInManager<IdentityUser> signInManager, IHubContext<ServiceHub> hubContext, IUrlHelper urlHelper, IHttpContextAccessor httpContextAccessor)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _authService = authService;
            _emailService = emailService;
            _otpService = otpService;
            _tokenService = tokenService;
            _signInManager = signInManager;
            _hubContext = hubContext;
            _urlHelper = urlHelper;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<(bool Succeeded, string Message, string ErrorMessage, string Token)> LoginUser(LoginRequest user)
        {
            var loginResult = await _authService.Login(user);
            if (!loginResult)
            {
                return (false, null, "User not Found", null);
            }
            var identityUser = await _userManager.FindByNameAsync(user.UserName);

            if (identityUser == null)
            {
                return (false, null, "User or password is wrong", null);
            }

            if (!identityUser.EmailConfirmed)
            {
                if (user != null)
                {
                    await SendConfirmationEmail(user.UserName, identityUser);
                }
                return (false, null, "Email not confirmed. A confirmation email has been sent.", null);
            }

            if (identityUser.TwoFactorEnabled)
            {
                var otp = _otpService.GenerateOTP();
                await _userManager.SetAuthenticationTokenAsync(identityUser, "2FA", "OTP", otp);
                await _emailService.SendEmailAsync(user.UserName, "Your OTP", $"Your OTP is {otp}");

                return (true, "OTP has been sent to your email. Please verify it.", null, null);
            }

            var roles = await _userManager.GetRolesAsync(identityUser);
            var tokenString = _authService.GenerateTokenString(user.UserName, roles, identityUser.Id);

            return (true, "Login Success!", null, tokenString);
        }

        public async Task<(bool Succeeded, string Message, string ErrorMessage)> RegisterUser(LoginUser user)
        {
            var existingUser = await _userManager.FindByEmailAsync(user.Email);
            if (existingUser != null)
            {
                return (false, null, "Error, email already in use!");
            }

            var existingPhoneUser = await _userManager.Users.SingleOrDefaultAsync(u => u.PhoneNumber == user.PhoneNumber);
            if (existingPhoneUser != null)
            {
                return (false, null, "Error, phone number already in use!");
            }

            if (await _authService.RegisterUser(user))
            {
                try
                {
                    var identityUser = await _userManager.FindByEmailAsync(user.Email);
                    await SendConfirmationEmail(user.UserName, identityUser);
                    // Check if the selected role is valid
                    if (user.Role != "JobSeeker" && user.Role != "Employer")
                    {
                        return (false, null, "Invalid role selected");
                    }

                    // Get the selected role
                    var selectedRole = await _roleManager.FindByNameAsync(user.Role);
                    if (selectedRole != null)
                    {
                        // Add the user to the selected role
                        var result = await _userManager.AddToRoleAsync(identityUser, selectedRole.Name);
                        if (!result.Succeeded)
                        {
                            return (false, null, "Error adding user to selected role");
                        }
                    }
                    // After the user has been successfully registered, send a notification to all connected clients
                    await _hubContext.Clients.All.SendAsync("createdUser", user);
                    return (true, "Create user successful! Please click on the link in the email to confirm your account.", null);
                }
                catch (Exception ex)
                {
                    return (false, null, "Error sending confirmation email");
                }
            }
            return (false, null, "Error, create account!");
        }



        private async Task SendConfirmationEmail(string userName, IdentityUser identityUser)
        {
            // Generate confirmation token
            var emailConfirmationToken = await _userManager.GenerateEmailConfirmationTokenAsync(identityUser);

            // Encode the userName
            var plainTextBytes = Encoding.UTF8.GetBytes(userName);
            var encodedUserName = Convert.ToBase64String(plainTextBytes);

            // Generate email confirmation link
            var request = _httpContextAccessor.HttpContext?.Request;
            if (request == null)
            {
                throw new InvalidOperationException("HTTP request is not available");
            }

            var emailConfirmationLink = _urlHelper.Action(
               nameof(AuthController.ConfirmEmail),
               "Auth",
               new { userName = encodedUserName, token = emailConfirmationToken },
               request.Scheme
           );

            string emailSubject = "Confirm your email";
            string emailContent = $"<h1>Welcome to our application!</h1><p>Thank you for registering. Please click the following <a href='{emailConfirmationLink}'>Click Here</a> to confirm your account...</p>";

            await _emailService.SendEmailAsync(userName, emailSubject, emailContent);
        }



        public async Task<bool> ConfirmEmailAsync(string userName, string token)
        {
            // Decode the userName
            var base64EncodedBytes = Convert.FromBase64String(userName);
            var decodedUserName = Encoding.UTF8.GetString(base64EncodedBytes);

            // Confirm the email
            var user = await _userManager.FindByNameAsync(decodedUserName);
            if (user == null)
            {
                return false;
            }

            var result = await _userManager.ConfirmEmailAsync(user, token);
            return result.Succeeded;
        }


        public async Task<IActionResult> HandleLogoutAsync(string token)
        {
            var result = await _tokenService.InvalidateToken(token);
            if (result)
            {
                return new OkObjectResult(new { message = "Logout successful" });
            }

            return new BadRequestObjectResult(new { message = "Error logging out" });
        }

        public async Task<IActionResult> CheckPhoneNumberAsync(LoginWithPhone phoneNumber)
        {
            var user = await _userManager.Users.SingleOrDefaultAsync(u => u.PhoneNumber == phoneNumber.PhoneNumber);
            if (user == null)
            {
                return new OkObjectResult(new { Exists = false, Message = "Phone number does not exist in the system." });
            }

            return new OkObjectResult(new { Exists = true, Message = "Phone number exists in the system." });
        }

        public async Task<IActionResult> LoginWithPhoneNumberAsync(LoginWithPhone model)
        {
            var user = await _userManager.Users.SingleOrDefaultAsync(u => u.PhoneNumber == model.PhoneNumber);
            if (user == null)
            {
                return new BadRequestObjectResult("Invalid phone number.");
            }

            var roles = await _userManager.GetRolesAsync(user);
            var tokenString = _authService.GenerateTokenString(user.UserName, roles, user.Id);

            return new OkObjectResult(new { Message = "Login Success!", Token = tokenString });
        }

        public async Task<IActionResult> ForgotPasswordAsync(ForgotPassword model, IUrlHelper urlHelper, HttpRequest request)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
            {
                // Don't reveal that the user does not exist
                return new BadRequestObjectResult("User doesn't exist in system");
            }

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            var encodedUserIdAndToken = Convert.ToBase64String(Encoding.UTF8.GetBytes($"{user.Id}:{token}"));
            var callbackUrl = $"http://localhost:3000/signin?resetPassword=true&id={encodedUserIdAndToken}";

            string emailSubject = "Reset Password";
            string emailContent = $"Please reset your password by clicking <a href='{callbackUrl}'>here</a>";

            await _emailService.SendEmailAsync(model.Email, emailSubject, emailContent);

            return new OkObjectResult("Your request has been successful. Please check your email to reset your password");
        }

        public async Task<IActionResult> ResetPasswordAsync(string id, ResetPasswordModel model)
        {
            id = WebUtility.UrlDecode(id);
            var decodedUserIdAndToken = Encoding.UTF8.GetString(Convert.FromBase64String(id));
            var userId = decodedUserIdAndToken.Split(':')[0];
            var token = decodedUserIdAndToken.Split(':')[1];

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                // Don't reveal that the user does not exist
                return new BadRequestObjectResult("Invalid user");
            }

            var result = await _userManager.ResetPasswordAsync(user, token, model.NewPassword);
            if (result.Succeeded)
            {
                return new OkObjectResult("Updated password successfully");
            }

            var modelState = new ModelStateDictionary();
            foreach (var error in result.Errors)
            {
                modelState.AddModelError(string.Empty, error.Description);
            }
            return new BadRequestObjectResult(modelState);
        }

        public async Task<IActionResult> LoginOTPEmailAsync(VerifyUser userFA)
        {
            var user = await _userManager.FindByNameAsync(userFA.UserName);
            var storedOtp = await _userManager.GetAuthenticationTokenAsync(user, "2FA", "OTP");

            if (storedOtp != userFA.otp)
            {
                // OTP does not match
                return new BadRequestObjectResult("Invalid OTP.");
            }

            // Get user roles
            var roles = await _userManager.GetRolesAsync(user);

            var tokenString = _authService.GenerateTokenString(userFA.UserName, roles, user.Id);
            return new OkObjectResult(new { Message = "Login Success!", Token = tokenString });
        }

        //logic login with google
        public async Task<IActionResult> HandleGoogleResponseAsync(string role, string email, AuthenticateResult result)
        {
            var user = await _userManager.FindByEmailAsync(email);

            if (user == null)
            {
                var newUser = new IdentityUser { UserName = email, Email = email };
                var createResult = await _userManager.CreateAsync(newUser);
                if (createResult.Succeeded)
                {
                    user = newUser;
                    var loginUser = new LoginUser { UserName = user.UserName };
                    await SendConfirmationEmail(loginUser.UserName, user);
                    await _authService.AddUserInfo(result.Principal, newUser);

                    if (role.ToLower() != "jobseeker" && role.ToLower() != "employer")
                    {
                        return new BadRequestObjectResult(new { status = false, message = "Invalid role selected" });
                    }

                    var selectedRole = await _roleManager.FindByNameAsync(role);
                    if (selectedRole != null)
                    {
                        var addToRoleResult = await _userManager.AddToRoleAsync(user, selectedRole.Name);
                        if (!addToRoleResult.Succeeded)
                        {
                            return new BadRequestObjectResult(new { status = false, message = "Error adding user to selected role" });
                        }
                    }

                    return new RedirectResult("http://localhost:3000/signin?checkConfirm=true");
                }
                else
                {
                    return new BadRequestObjectResult("Error creating new user");
                }
            }

            if (!user.EmailConfirmed)
            {
                var loginUser = new LoginUser { UserName = user.UserName };
                await SendConfirmationEmail(loginUser.UserName, user);
                return new RedirectResult("http://localhost:3000/signin?checkConfirm=true");
            }

            var roles = await _userManager.GetRolesAsync(user);
            var tokenString = _authService.GenerateTokenString(user.UserName, roles, user.Id);

            if (user.TwoFactorEnabled)
            {
                var otp = _otpService.GenerateOTP();
                await _userManager.SetAuthenticationTokenAsync(user, "2FA", "OTP", otp);
                await _emailService.SendEmailAsync(user.UserName, "Your OTP", $"Your OTP is {otp}");
                return new RedirectResult($"http://localhost:3000/signin?checkOTP={tokenString}");
            }

            return new RedirectResult($"http://localhost:3000/callback?token={tokenString}");
        }

        public async Task<IActionResult> HandleFacebookResponseAsync(string role, ExternalLoginInfo info)
        {
            var result = await _signInManager.ExternalLoginSignInAsync(info.LoginProvider, info.ProviderKey, isPersistent: false, bypassTwoFactor: true);
            if (result.Succeeded)
            {
                var user = await _userManager.FindByLoginAsync(info.LoginProvider, info.ProviderKey);

                // Get user roles
                var roles = await _userManager.GetRolesAsync(user);

                var tokenString = _authService.GenerateTokenString(user.UserName, roles, user.Id);
                return new OkObjectResult(new { Message = "Login Success!", Token = tokenString });
            }
            else
            {
                var email = info.Principal.FindFirstValue(ClaimTypes.Email);
                var user = new IdentityUser { UserName = email, Email = email };
                var identityResult = await _userManager.CreateAsync(user);

                if (identityResult.Succeeded)
                {
                    var loginResult = await _userManager.AddLoginAsync(user, info);
                    if (loginResult.Succeeded)
                    {
                        // Add user info
                        await _authService.AddUserInfo(info.Principal, user);

                        // Check if the selected role is valid
                        if (role.ToLower() != "jobseeker" && role.ToLower() != "employer")
                        {
                            return new BadRequestObjectResult(new { status = false, message = "Invalid role selected" });
                        }

                        // Get the selected role
                        var selectedRole = await _roleManager.FindByNameAsync(role);
                        if (selectedRole != null)
                        {
                            // Add the user to the selected role
                            var addToRoleResult = await _userManager.AddToRoleAsync(user, selectedRole.Name);
                            if (!addToRoleResult.Succeeded)
                            {
                                return new BadRequestObjectResult(new { status = false, message = "Error adding user to selected role" });
                            }
                        }

                        await _signInManager.SignInAsync(user, isPersistent: false);
                        var roles = await _userManager.GetRolesAsync(user);

                        var tokenString = _authService.GenerateTokenString(user.UserName, roles, user.Id);
                        return new OkObjectResult(new { Message = "Login Success!", Token = tokenString });
                    }
                    else
                    {
                        return new BadRequestObjectResult(new { Message = "Error adding external login", loginResult.Errors });
                    }
                }
                else
                {
                    return new BadRequestObjectResult(new { Message = "Error creating user", identityResult.Errors });
                }
            }
        }
     }
}
