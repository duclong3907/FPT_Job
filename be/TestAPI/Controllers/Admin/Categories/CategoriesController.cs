using Microsoft.AspNetCore.Mvc;
using TestAPI.Models;
using TestAPI.Repository.CategoryRepo;

namespace TestAPI.Controllers.Admin.Categories
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoriesController : ControllerBase
    {
        private readonly ICategoryRepository _jobCategories;
        public CategoriesController(ICategoryRepository jobCategories)
        {
            _jobCategories = jobCategories;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            try
            {
                var jobCategories = await _jobCategories.GetAll();
                if (jobCategories is null) return NotFound(new { message = "No data" });

                return Ok(new { jobCategories, message = "Retrieve successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving the category" });
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            try
            {
                var jobCategoies = await _jobCategories.GetById(id);
                if (jobCategoies == null) return NotFound(new { message = "Id not found" });
                return Ok(jobCategoies);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while retrieving the job" });
            }
        }

        [HttpPost]
        public async Task<IActionResult> Post(JobCategories category)
        {
            try
            {
                return await _jobCategories.CreateCategoryAsync(category);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while create the category" });
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, JobCategories category)
        {
            try
            {
                return await _jobCategories.UpdateCategoryAsync(id, category);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while update the job" });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCategory(int id)
        {
            try
            {
                return await _jobCategories.DeleteCategoryAsync(id);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, new { message = "An error occurred while deleted the category" });
            }
        }
    }
}
