using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using TestAPI.Models.Auth;
using TestAPI.Repository.UserRepo;

namespace TestAPI.Controllers.Admin.Users
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUserRepository _userRepository;
        public UserController(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<object>> GetUser(string id)
        {
            try
            {
                var userInfo = await _userRepository.GetByUserId(id);
                if (userInfo == null) return NotFound(new { message = "Id not found!" });

                var roles = await _userRepository.GetRolesAsync(userInfo.UserId);
                var identityUser = await _userRepository.GetIdentityUserById(userInfo.UserId);

                return new
                {
                    user = identityUser,
                    roles = roles,
                    fullName = userInfo?.FullName,
                    image = userInfo?.Image,
                    company = userInfo?.Company,
                };
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing request.");
            }
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var users = await _userRepository.GetAll();
            var userRoles = new List<object>();

            foreach (var user in users)
            {
                var roles = await _userRepository.GetRolesAsync(user.UserId);
                var identityUser = await _userRepository.GetIdentityUserById(user.UserId);
                userRoles.Add(new
                {
                    user = identityUser,
                    roles = roles,
                    fullName = user.FullName,
                    image = user.Image,
                    company = user.Company
                });
            }

            return Ok(userRoles);
        }

        // POST: api/User
        [HttpPost]
        public async Task<ActionResult<IdentityUser>> PostUser(LoginUser model)
        {
            var (Succeeded, ErrorMessage) = await _userRepository.CreateUserAsync(model);
            if (!Succeeded)
            {
                return BadRequest(new { status = false, error = ErrorMessage });
            }
            return Ok("Create user Successfully");
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(string id, LoginUser model)
        {
            try
            {
                var (Succeeded, ErrorMessage) = await _userRepository.UpdateUserAsync(id, model);
                if (!Succeeded)
                {
                    return BadRequest(new { status = false, error = ErrorMessage });
                }

                return Ok("Update user Successfully");
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing updated.");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(string id)
        {
            try
            {
                var (Succeeded, ErrorMessage) = await _userRepository.DeleteUserAsync(id);
                if (!Succeeded)
                {
                    return BadRequest(new { status = false, error = ErrorMessage });
                }

                return Ok("Delete user Successfully");
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing deleted.");
            }
        }
    }
}