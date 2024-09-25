using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using TestAPI.Contextes;
using TestAPI.Models;
using TestAPI.Services.HubService;

namespace TestAPI.Repository.JobRepo
{
    public class JobRepository : Repository<Job>, IJobRepository
    {
        private readonly AuthDemoDbContext _context;
        private readonly IHubContext<ServiceHub> _hubContext;
        private readonly IRepository<Job> _job;
        public JobRepository(AuthDemoDbContext context, IRepository<Job> job, IHubContext<ServiceHub> hubContext) : base(context)
        {
            _context = context;
            _job = job;
            _hubContext = hubContext;
        }
        public async Task<IActionResult> CreateJobAsync(Job job)
        {
            var newJob = new Job
            {
                Title = job.Title,
                Image = job.Image,
                Description = job.Description,
                SalaryRange = job.SalaryRange,
                Experience_required = job.Experience_required,
                Education_required = job.Education_required,
                Skill_required = job.Skill_required,
                Application_deadline = job.Application_deadline,
                status = "open",
                EmployerId = job.EmployerId,
                JobCategoryId = job.JobCategoryId,
                Created_At = DateTime.Now,
                Updated_At = DateTime.Now,
                Deleted = 0
            };
            await _job.Add(newJob);

            await _hubContext.Clients.All.SendAsync("createdJob", newJob);
            return new OkObjectResult(new { job = newJob, message = "Create job successfully" });
        }

        public async Task<IActionResult> UpdateJobAsync(int id, Job job)
        {
            var jobUpdate = await _job.GetByNotSoftDeletedId(id);
            if (jobUpdate == null) return new NotFoundObjectResult(new { message = "Id not found" });

            jobUpdate.Title = job.Title;
            jobUpdate.Image = job.Image;
            jobUpdate.Description = job.Description;
            jobUpdate.SalaryRange = job.SalaryRange;
            jobUpdate.Experience_required = job.Experience_required;
            jobUpdate.Education_required = job.Education_required;
            jobUpdate.Skill_required = job.Skill_required;
            jobUpdate.Application_deadline = job.Application_deadline;
            jobUpdate.status = job.status;
            jobUpdate.EmployerId = job.EmployerId;
            jobUpdate.JobCategoryId = job.JobCategoryId;
            jobUpdate.Updated_At = DateTime.Now;

            await _job.Update(jobUpdate);

            await _hubContext.Clients.All.SendAsync("updatedJob", jobUpdate);
            return new OkObjectResult(new { message = "Update job successfully" });
        }

        public async Task<IActionResult> DeleteJobAsync(int id)
        {
            var jobUpdate = await _job.GetByNotSoftDeletedId(id);
            if (jobUpdate == null) return new NotFoundObjectResult(new { message = "Id not found" });

            var relatedApplications = await _context.Applications.AnyAsync(a => a.JobId == id);

            if (relatedApplications)
            {
                return new BadRequestObjectResult(new { message = "Please delete related applications before deleting this job." });
            }

            jobUpdate.Deleted = 1;
            _job.Update(jobUpdate);

            await _hubContext.Clients.All.SendAsync("deletedJob", jobUpdate);
            return new OkObjectResult(new { message = "Delete job successfully" });
        }

        public async Task<IActionResult> GetApplicationsForJob(int jobId)
        {
            var applications = await _context.Applications
                    .Where(app => app.JobId == jobId)
                    .Join(_context.Users,
                          app => app.UserId,
                          user => user.Id,
                          (app, user) => new { app, user })
                    .Join(_context.UserInfos,
                          combined => combined.user.Id,
                          userInfo => userInfo.UserId,
                          (combined, userInfo) => new
                          {
                              Id = combined.app.Id,
                              UserId = combined.user.Id,
                              UserName = combined.user.UserName,
                              FullName = userInfo.FullName,
                              JobId = jobId,
                              Image = userInfo.Image,
                              UserEmail = combined.user.Email,
                              Status = combined.app.status,
                              Resume = combined.app.resume,
                              CoverLetter = combined.app.coverLetter,
                              SelfIntroduction = combined.app.selfIntroduction,
                              ApplicationStatus = combined.app.status,
                              AppliedDate = combined.app.Created_At
                          })
                    .ToListAsync();

            if (applications == null || !applications.Any())
            {
                return new NotFoundObjectResult(new { message = "No applications found for this job" });
            }

            return new OkObjectResult(new { applications, message = "Retrieve successfully" });
        }
    }
}
