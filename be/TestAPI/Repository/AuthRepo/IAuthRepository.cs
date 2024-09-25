using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using TestAPI.Models.Auth;

namespace TestAPI.Repository.AuthRepo
{
    public interface IAuthRepository
    {
        Task<(bool Succeeded, string Message,string ErrorMessage)> RegisterUser(LoginUser user);
        Task<(bool Succeeded, string Message, string ErrorMessage, string Token)> LoginUser(LoginRequest user);
        Task<IActionResult> HandleGoogleResponseAsync(string role, string email, AuthenticateResult result);
        Task<IActionResult> HandleFacebookResponseAsync(string role, ExternalLoginInfo info);
        Task<IActionResult> HandleLogoutAsync(string token);
        Task<IActionResult> CheckPhoneNumberAsync(LoginWithPhone phoneNumber);
        Task<IActionResult> LoginWithPhoneNumberAsync(LoginWithPhone model);
        Task<IActionResult> ForgotPasswordAsync(ForgotPassword model, IUrlHelper urlHelper, HttpRequest request);
        Task<IActionResult> ResetPasswordAsync(string id, ResetPasswordModel model);
        Task<IActionResult> LoginOTPEmailAsync(VerifyUser userFA);
    }
}
