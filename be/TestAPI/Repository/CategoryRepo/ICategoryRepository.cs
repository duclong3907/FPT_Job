using Microsoft.AspNetCore.Mvc;
using TestAPI.Models;
using TestAPI.Models.Auth;

namespace TestAPI.Repository.CategoryRepo
{
    public interface ICategoryRepository : IRepository<JobCategories>
    {
        Task<IActionResult> CreateCategoryAsync(JobCategories category);
        Task<IActionResult> UpdateCategoryAsync(int id, JobCategories category);
        Task<IActionResult> DeleteCategoryAsync(int id);
    }
}
