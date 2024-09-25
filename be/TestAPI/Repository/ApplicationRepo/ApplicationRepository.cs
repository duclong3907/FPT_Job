using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using TestAPI.Contextes;
using TestAPI.Models;
using TestAPI.Services.HubService;


namespace TestAPI.Repository.ApplicationRepo
{
    public class ApplicationRepository : Repository<Application>, IApplicationRepository
    {
        private readonly AuthDemoDbContext _context;
        private readonly IHubContext<ServiceHub> _hubContext;
        private readonly IRepository<Application> _application;
        public ApplicationRepository(AuthDemoDbContext context, IRepository<Application> application, IHubContext<ServiceHub> hubContext) : base(context)
        {
            _context = context;
            _application = application;
            _hubContext = hubContext;
        }

        public async Task<IActionResult> CreateApplicationAsync(Application application)
        {
            //check jobseeker apply job
            var existingApplication = await _context.Applications
            .FirstOrDefaultAsync(a => a.JobId == application.JobId && a.UserId == application.UserId);

            if (existingApplication != null)
            {
                return new BadRequestObjectResult(new { message = "You have already applied for this job" });
            }
            var newApplication = new Application
            {
                resume = application.resume,
                coverLetter = application.coverLetter,
                selfIntroduction = application.selfIntroduction,
                status = "pending",
                JobId = application.JobId,
                UserId = application.UserId,
                Created_At = DateTime.Now,
                Updated_At = DateTime.Now,
                Deleted = 0
            };
            await _application.Add(newApplication);

            await _hubContext.Clients.All.SendAsync("createdApplication", newApplication.JobId, newApplication);
            return new OkObjectResult(new { message = "Application created successfully" });
        }

        public async Task<IActionResult> UpdateApplicationAsync(int id, Application application)
        {
            var applicationToUpdate = await _application.GetById(id);
            if (applicationToUpdate == null) return new NotFoundObjectResult(new { message = "Id not found" });

            applicationToUpdate.resume = application.resume;
            applicationToUpdate.coverLetter = application.coverLetter;
            applicationToUpdate.selfIntroduction = application.selfIntroduction;
            applicationToUpdate.status = application.status;
            applicationToUpdate.JobId = application.JobId;
            applicationToUpdate.UserId = application.UserId;
            applicationToUpdate.Updated_At = DateTime.Now;

            await _application.Update(applicationToUpdate);

            await _hubContext.Clients.All.SendAsync("updatedApplication", applicationToUpdate.JobId, applicationToUpdate);
            return new OkObjectResult(new { message = "Application updated successfully" });
        }

        public async Task<IActionResult> DeleteApplicationAsync(int id)
        {
            var applicationToDelete = _context.Applications.Find(id);
            if (applicationToDelete == null) return new NotFoundObjectResult(new { message = "Id not found" });

            await _application.Delete(applicationToDelete);

            await _hubContext.Clients.All.SendAsync("deletedApplication", applicationToDelete.JobId, applicationToDelete);
            return new OkObjectResult(new { message = "Application deleted successfully" });
        }


        public async Task<IActionResult> UserApplications(string userId)
        {
            var applications = await _context.Applications
                    .Where(app => app.UserId == userId)
                    .ToListAsync();

            if (applications == null || !applications.Any())
            {
                return new NotFoundObjectResult(new { message = "No applications found for this user" });
            }

            return new OkObjectResult(new { applications, message = "Retrieve successfully" });
        }

        public async Task<IActionResult> UserAppliedJobs(string userId)
        {
            var appliedJobs = await _context.Applications
                    .Where(app => app.UserId == userId)
                    .Join(_context.Jobs,
                          app => app.JobId,
                          job => job.Id,
                          (app, job) => new
                          {
                              JobId = job.Id,
                              JobTitle = job.Title,
                              JobDescription = job.Description,
                              AppliedDate = app.Created_At,
                              ApplicationStatus = app.status
                          })
                    .ToListAsync();

            if (appliedJobs == null || !appliedJobs.Any())
            {
                return new NotFoundObjectResult(new { message = "No jobs found for this user" });
            }

            return new OkObjectResult(new { appliedJobs, message = "Retrieve successfully" });
        }
    }
}
