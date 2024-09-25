using Microsoft.AspNetCore.Identity;
using TestAPI.Models.Auth;
using TestAPI.Models;

namespace TestAPI.Repository.UserRepo
{
    public interface IUserRepository : IRepository<UserInfo>
    {
        Task<(bool Succeeded, string ErrorMessage)> CreateUserAsync(LoginUser model);
        Task<(bool Succeeded, string ErrorMessage)> UpdateUserAsync(string id, LoginUser model);
        Task<(bool Succeeded, string ErrorMessage)> DeleteUserAsync(string id);
        Task<UserInfo> GetByUserId(string userId);
        Task<IList<string>> GetRolesAsync(string userId);
        Task<IdentityUser> GetIdentityUserById(string userId);
    }
}
