using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using TestAPI.Contextes;
using TestAPI.Models;
using TestAPI.Services.HubService;

namespace TestAPI.Repository.CategoryRepo
{
    public class CategoryRepository : Repository<JobCategories>, ICategoryRepository
    {
        private readonly AuthDemoDbContext _context;
        private readonly IHubContext<ServiceHub> _hubContext;
        private readonly IRepository<JobCategories>  _jobCategories;

        public CategoryRepository(AuthDemoDbContext context,
            IHubContext<ServiceHub> hubContext, IRepository<JobCategories> jobCategories) : base(context)
        {
            _context = context;
            _hubContext = hubContext;
            _jobCategories = jobCategories;
        }


        public async Task<IActionResult> CreateCategoryAsync(JobCategories category)
        {
            var newCategory = new JobCategories
            {
                Name = category.Name
            };
            if (newCategory is null)
                return new BadRequestObjectResult(new { employee = newCategory, message = "Retrieve successfully" });

            await _jobCategories.Add(newCategory);
            await _hubContext.Clients.All.SendAsync("createdCategory", newCategory);

            return new OkObjectResult(new { category = newCategory, message = "Create category successfully" });
        }

        public async Task<IActionResult> UpdateCategoryAsync(int id, JobCategories category)
        {
            var categoryUpdate = await _jobCategories.GetById(id);
            if (categoryUpdate == null)
            {
                return new NotFoundObjectResult(new { message = "Id not found" });
            }
            categoryUpdate.Name = category.Name;
            await _jobCategories.Update(categoryUpdate);

            await _hubContext.Clients.All.SendAsync("updatedCategory", categoryUpdate);
            return new OkObjectResult(new { message = "Update category successfully" });
        }

        public async Task<IActionResult> DeleteCategoryAsync(int id)
        {
            var category = await _jobCategories.GetById(id);
            if (category == null) return new NotFoundObjectResult(new { message = "Id not found" });

            var relatedJobs = await _context.Jobs.Where(j => j.JobCategoryId == id).ToListAsync();
            // ktra xem tk con đã xoá mềm hay chưa
            if (relatedJobs.Any(j => j.Deleted == 0))
            {
                return new BadRequestObjectResult(new { message = "Can't delete category because it has related jobs that are not deleted" });
            }
            // nếu tk con đã xoá mềm rồi thì thực hiện xoá cứng tk con và tk cha
            foreach (var job in relatedJobs)
            {
                _context.Jobs.Remove(job);
            }
            _context.JobCategories.Remove(category);
            _context.SaveChanges();

            await _hubContext.Clients.All.SendAsync("deletedCategory", category);
            return new OkObjectResult(new { message = "Delete category successfully" });
        }
    }
}
