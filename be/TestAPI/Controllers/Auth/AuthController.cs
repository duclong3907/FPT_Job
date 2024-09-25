using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Google;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TestAPI.Models.Auth;
using TestAPI.Repository.AuthRepo;


namespace TestAPI.Controllers.Auth
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IAuthRepository _authRepository;
        private readonly SignInManager<IdentityUser> _signInManager;


        public AuthController(IAuthRepository authRepository, SignInManager<IdentityUser> signInManager)
        {
            _authRepository = authRepository;
            _signInManager = signInManager;
        }

        [HttpPost("Register")]
        public async Task<IActionResult> RegisterUser(LoginUser user)
        {
            var (Succeeded, Message, ErrorMessage) = await _authRepository.RegisterUser(user);
            if (Succeeded)
            {
                return Ok(new { status = true, message = Message });
            }
            return BadRequest(new { status = false, message = ErrorMessage });
        }


        [HttpPost("Login")]
        public async Task<IActionResult> Login(LoginRequest user)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new { status = false, message = "User not Found", user = ModelState });
            }
            var (Succeeded, Message, ErrorMessage, tokenString) = await _authRepository.LoginUser(user);
            if (Succeeded)
            {
                return Ok(new { status = true, message = Message, Token = tokenString });
            }
            return BadRequest(new { status = false, message = ErrorMessage });
        }

        [HttpPost("Login-2FA-Email")]
        public async Task<IActionResult> loginOTPEmail(VerifyUser userFA)
        {
            return await _authRepository.LoginOTPEmailAsync(userFA);
        }


        [HttpPost("CheckPhoneNumber")]
        public async Task<IActionResult> CheckPhoneNumber(LoginWithPhone phoneNumber)
        {
            return await _authRepository.CheckPhoneNumberAsync(phoneNumber);
        }

        [HttpPost("LoginWithPhoneNumber")]
        public async Task<IActionResult> LoginWithPhoneNumber(LoginWithPhone model)
        {
            return await _authRepository.LoginWithPhoneNumberAsync(model);
        }



        [HttpPost("logout")]
        public async Task<IActionResult> Logout()
        {
            var authHeader = Request.Headers["Authorization"].ToString().Split(' ');
            if (authHeader.Length < 2)
            {
                // Handle the case where the token is missing
                return BadRequest("Token is missing");
            }
            var token = authHeader[1];

            return await _authRepository.HandleLogoutAsync(token);
        }


        [HttpPost("ForgotPassword")]
        public async Task<IActionResult> ForgotPassword([FromBody] Models.Auth.ForgotPassword model)
        {
            return await _authRepository.ForgotPasswordAsync(model, Url, Request);
        }

        [HttpPut("ResetPassword/{id}")]
        public async Task<IActionResult> ResetPassword(string id, [FromBody] ResetPasswordModel model)
        {
            return await _authRepository.ResetPasswordAsync(id, model);
        }

        [HttpGet("LoginGoogle")]
        public IActionResult LoginGoogle(string role)
        {
            var properties = new AuthenticationProperties { RedirectUri = Url.Action("GoogleResponse", new { role }) };
            return Challenge(properties, GoogleDefaults.AuthenticationScheme);
        }

        [HttpGet("GoogleResponse")]
        public async Task<IActionResult> GoogleResponse(string role)
        {
            var result = await HttpContext.AuthenticateAsync(GoogleDefaults.AuthenticationScheme);

            if (result?.Succeeded != true)
            {
                return BadRequest();
            }

            var email = result.Principal.FindFirstValue(ClaimTypes.Email);

            return await _authRepository.HandleGoogleResponseAsync(role, email, result);
        }



        [HttpPost("LogoutGoogle")]
        public async Task<IActionResult> LogoutGoogle()
        {
            await HttpContext.SignOutAsync(IdentityConstants.ApplicationScheme);
            return Redirect("http://localhost:3000");
        }

        [HttpGet("signin-facebook")]
        public IActionResult SignInFacebook(string role)
        {
            var redirectUrl = Url.Action("FacebookResponse", "Auth", new { role });
            var properties = _signInManager.ConfigureExternalAuthenticationProperties("Facebook", redirectUrl);
            return new ChallengeResult("Facebook", properties);
        }

        [HttpGet("facebook-response")]
        public async Task<IActionResult> FacebookResponse(string role)
        {
            var info = await _signInManager.GetExternalLoginInfoAsync();
            if (info == null)
            {
                return BadRequest(new { Message = "Error retrieving external login info" });
            }

            return await _authRepository.HandleFacebookResponseAsync(role, info);
        }
    }
}