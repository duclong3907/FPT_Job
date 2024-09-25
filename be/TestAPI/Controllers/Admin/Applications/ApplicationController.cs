using Microsoft.AspNetCore.Mvc;
using TestAPI.Models;
using TestAPI.Repository.ApplicationRepo;

namespace TestAPI.Controllers.Admin.Applications
{
    [Route("api/[controller]")]
    [ApiController]
    public class ApplicationController : ControllerBase
    {
        private readonly IApplicationRepository _application;
        public ApplicationController(IApplicationRepository application)
        {
            _application = application;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            try
            {
                var applications = await _application.GetAll();
                if (applications is null || !applications.Any()) return NotFound(new { message = "No data" });

                return Ok(new { applications, message = "Retrieve successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving applications" });
            }
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            try
            {
                var application = await _application.GetById(id);
                if (application == null) return NotFound(new { message = "Id not found" });
                return Ok(application);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving the application" });
            }
        }

        

        [HttpPost]
        public async Task<IActionResult> Post(Application application)
        {
            try
            {
                return await _application.CreateApplicationAsync(application);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while creating the application" });
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, Application application)
        {
            try
            {                
                return await _application.UpdateApplicationAsync(id, application);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while updating the application" });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                return await _application.DeleteApplicationAsync(id);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while deleting the application" });
            }
        }

        [HttpGet("User/{userId}")]
        public async Task<IActionResult> GetUserApplications(string userId)
        {
            try
            {
                return await _application.UserApplications(userId);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving user applications" });
            }
        }

        [HttpGet("User/{userId}/Jobs")]
        public async Task<IActionResult> GetUserAppliedJobs(string userId)
        {
            try
            {
                return await _application.UserAppliedJobs(userId);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving applied jobs" });
            }
        }
    }
}
