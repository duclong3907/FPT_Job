using Microsoft.AspNetCore.Mvc;
using TestAPI.Models;

namespace TestAPI.Repository.ApplicationRepo
{
    public interface IApplicationRepository : IRepository<Application>
    {
        Task<IActionResult> CreateApplicationAsync(Application application);
        Task<IActionResult> UpdateApplicationAsync(int id, Application application);
        Task<IActionResult> DeleteApplicationAsync(int id);
        Task<IActionResult> UserAppliedJobs(string userId);
        Task<IActionResult> UserApplications(string userId);
    }
}
