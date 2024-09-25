using Microsoft.AspNetCore.Mvc;
using TestAPI.Models;

namespace TestAPI.Repository.JobRepo
{
    public interface IJobRepository : IRepository<Job>
    {
        Task<IActionResult> CreateJobAsync(Job job);
        Task<IActionResult> UpdateJobAsync(int id, Job job);
        Task<IActionResult> DeleteJobAsync(int id);
        Task<IActionResult> GetApplicationsForJob(int jobId);
    }
}
