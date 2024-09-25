using Microsoft.AspNetCore.Mvc;
using TestAPI.Models;
using TestAPI.Repository.JobRepo;


namespace TestAPI.Controllers.Admin.Jobs
{
    [Route("api/[controller]")]
    [ApiController]
    //[Authorize(Roles="Admin")]
    public class JobController : ControllerBase
    {
        private readonly IJobRepository _job;
        public JobController(IJobRepository job)
        {
            _job = job;
        }
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            try
            {
                var jobs = await _job.GetAllNotSoftDeleted();
                if (jobs is null) return NotFound(new { message = "No data" });

                return Ok(new { jobs, message = "Retrieve successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving jobs" });
            }
        }


        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            try
            {
                //var job = await _context.Jobs.FirstOrDefaultAsync(j => j.Id == id && j.Deleted == 0);
                var job = await _job.GetByNotSoftDeletedId(id);
                if (job == null) return NotFound(new { message = "Id not found" });
                return Ok(job);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving the job" });
            }
        }


        [HttpPost]
        public async Task<IActionResult> Post(Job job)
        {
            try
            {
                return await _job.CreateJobAsync(job);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, Job job)
        {
            try
            {
                return await _job.UpdateJobAsync(id, job);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while update the job" });
            }
        }

        // DELETE: api/Jobs/id
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                return await _job.DeleteJobAsync(id);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while deleted the job" });
            }
        }

        [HttpGet("{jobId}/Applications")]
        public async Task<IActionResult> FetchApplicationsForJob(int jobId)
        {
            try
            {
                return await _job.GetApplicationsForJob(jobId);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving applications for the job" });
            }
        }
    }
}
