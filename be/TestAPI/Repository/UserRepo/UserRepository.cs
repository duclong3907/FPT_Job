using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using TestAPI.Contextes;
using TestAPI.Models.Auth;
using TestAPI.Models;
using TestAPI.Repository.UserRepo;
using TestAPI.Repository;
using Microsoft.AspNetCore.SignalR;
using TestAPI.Services.HubService;

namespace AppAPI.Repository
{
    public class UserRepository : Repository<UserInfo>, IUserRepository
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly AuthDemoDbContext _context;
        private readonly IHubContext<ServiceHub> _hubContext;

        public UserRepository(AuthDemoDbContext context, UserManager<IdentityUser> userManager, 
            RoleManager<IdentityRole> roleManager, IHubContext<ServiceHub> hubContext)
            : base(context)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _context = context;
            _hubContext = hubContext;
        }

        public async Task<(bool Succeeded, string ErrorMessage)> CreateUserAsync(LoginUser model)
        {
            var existingEmailUser = await _userManager.FindByEmailAsync(model.Email);
            if (existingEmailUser != null)
            {
                return (false, "Email already exists.");
            }

            var existingPhoneUser = await _userManager.Users.SingleOrDefaultAsync(u => u.PhoneNumber == model.PhoneNumber);
            if (existingPhoneUser != null)
            {
                return (false, "Phone number already in use!");
            }
            var user = new IdentityUser
            {
                UserName = model.UserName,
                Email = model.Email,
                PhoneNumber = model.PhoneNumber
            };

            if (string.IsNullOrEmpty(model.Password))
            {
                return (false, "Password cannot be null or empty.");
            }

            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded)
            {
                return (false, string.Join(", ", result.Errors.Select(e => e.Description)));
            }

            var roleExists = await _roleManager.RoleExistsAsync(model.Role);
            if (!roleExists)
            {
                return (false, $"Role '{model.Role}' does not exist.");
            }

            result = await _userManager.AddToRoleAsync(user, model.Role);
            if (!result.Succeeded)
            {
                return (false, string.Join(", ", result.Errors.Select(e => e.Description)));
            }

            //CreatedAtAction("GetUser", new { id = user.Id }, user);
            var userInfo = new UserInfo
            {
                UserId = user.Id,
                FullName = model.FullName,
                Company = model.Company,
                Skill = "",
                Expericene = "",
            };
            await Add(userInfo);
            // notification clients
            await _hubContext.Clients.All.SendAsync("createdUser", user);
            return (true, "Create user Successfully");

        }

        public async Task<(bool Succeeded, string ErrorMessage)> UpdateUserAsync(string id, LoginUser model)
        {

            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return (false, "Id not Found!");

            var existingUser = await _userManager.FindByEmailAsync(model.Email);
            if (existingUser != null && existingUser.Id != id)
            {
                return (false, "Email already exists.");
            }

            var existingPhoneUser = await _userManager.Users.SingleOrDefaultAsync(u => u.PhoneNumber == model.PhoneNumber);
            if (existingPhoneUser != null && existingPhoneUser.Id != id)
            {
                return (false, "Phone number already in use!");
            }

            user.UserName = model.UserName;
            user.Email = model.Email;
            user.PhoneNumber = model.PhoneNumber;
            if (model.Password != null)
            {
                var passwordHasher = new PasswordHasher<IdentityUser>();
                user.PasswordHash = passwordHasher.HashPassword(user, model.Password);
            }

            var result = await _userManager.UpdateAsync(user);
            if (!result.Succeeded)
            {
                return (false, string.Join(", ", result.Errors.Select(e => e.Description)));
            }

            var userRole = await _userManager.GetRolesAsync(user);
            if (userRole.Count > 0)
            {
                await _userManager.RemoveFromRolesAsync(user, userRole);
            }

            var roleExists = await _roleManager.RoleExistsAsync(model.Role);
            if (!roleExists)
            {
                return (false, $"Role '{model.Role}' does not exist.");
            }

            result = await _userManager.AddToRoleAsync(user, model.Role);
            if (!result.Succeeded)
            {
                return (false, string.Join(", ", result.Errors.Select(e => e.Description)));
            }

            var userInfo = await _context.UserInfos.FirstOrDefaultAsync(u => u.UserId == id);
            if (userInfo == null)
            {
                return (false, "User info not found.");
            }

            userInfo.FullName = model.FullName;
            userInfo.Image = model.Image;
            userInfo.Company = model.Company;
            await _context.SaveChangesAsync();

            // notification clients
            await _hubContext.Clients.All.SendAsync("updatedUser", user);

            return (true, "Update user Successfully");

        }

        public async Task<(bool Succeeded, string ErrorMessage)> DeleteUserAsync(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null) return (false, "Id not Found!");

            // Find and delete related applications
            var applications = _context.Applications.Where(a => a.UserId == id);
            if (applications != null)
            {
                _context.Applications.RemoveRange(applications);
                await _context.SaveChangesAsync();
            }
            // Find and delete related Jobs
            var jobs = _context.Jobs.Where(a => a.EmployerId == id);
            if (jobs != null)
            {
                _context.Jobs.RemoveRange(jobs);
                await _context.SaveChangesAsync();
            }

            var result = await _userManager.DeleteAsync(user);
            if (!result.Succeeded)
            {
                return (false, string.Join(", ", result.Errors.Select(e => e.Description)));
            }

            // notification clients
            await _hubContext.Clients.All.SendAsync("deletedUser", user);

            return (true, "Delete user Successfully");
        }

        public async Task<UserInfo> GetByUserId(string userId)
        {
            return await _context.UserInfos.SingleOrDefaultAsync(u => u.UserId == userId);
        }

        public async Task<IList<string>> GetRolesAsync(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                return new List<string>();
            }
            return await _userManager.GetRolesAsync(user);
        }

        public async Task<IdentityUser> GetIdentityUserById(string userId)
        {
            return await _userManager.FindByIdAsync(userId);
        }
    }
}
