using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using TestAPI.Contextes;
using TestAPI.Repository;
using TestAPI.Repository.AuthRepo;
using TestAPI.Services;
using TestAPI.Services.Email;
using TestAPI.Services.HubService;
using TestAPI.Services.Token;
using AppAPI.Repository;
using TestAPI.Repository.UserRepo;
using TestAPI.Repository.CategoryRepo;
using TestAPI.Repository.JobRepo;
using TestAPI.Repository.ApplicationRepo;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(5000); // HTTP port
    serverOptions.ListenAnyIP(5001, listenOptions => listenOptions.UseHttps()); // HTTPS port
});

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<AuthDemoDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("AuthenDbContext") ?? throw new InvalidOperationException("Connection string 'AuthenDbContext' not found.")));

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReactApp",
        policyBuilder =>
        {
            policyBuilder.WithOrigins("http://localhost:3000");
            policyBuilder.AllowAnyHeader();
            policyBuilder.AllowAnyMethod();
            policyBuilder.AllowCredentials();
        });
});

builder.Services.AddIdentity<IdentityUser, IdentityRole>(options =>
{
    options.Password.RequiredLength = 5;
}).AddEntityFrameworkStores<AuthDemoDbContext>()
.AddDefaultTokenProviders();
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters()
    {
        ValidateActor = true,
        ValidateIssuer = true, // Ensures the token issuer matches the configured issuer (ValidIssuer).
        ValidateAudience = true, // Ensures the token audience matches the configured audience (ValidAudience).
        RequireExpirationTime = true, // Ensures the token is signed with the configured key (IssuerSigningKey)
        ValidateIssuerSigningKey = true, // Ensures the token is not expired
        ValidIssuer = builder.Configuration.GetSection("Jwt:Issuer").Value, // Sets the expected issuer of the token (obtained from app settings)
        ValidAudience = builder.Configuration.GetSection("Jwt:Audience").Value, // Sets the expected audience of the token (obtained from app settings)
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!))
    };
}).AddGoogle(options =>
{
    options.ClientId = builder.Configuration["Authentication:Google:ClientId"];
    options.ClientSecret = builder.Configuration["Authentication:Google:ClientSecret"];
}).AddFacebook(facebookOptions => {
    // Đọc cấu hình
    IConfigurationSection facebookAuthNSection = builder.Configuration.GetSection("Authentication:Facebook");
    facebookOptions.AppId = facebookAuthNSection["AppId"];
    facebookOptions.AppSecret = facebookAuthNSection["AppSecret"];
    facebookOptions.CallbackPath = "/signin-facebook";
});

//// Register repositories
builder.Services.AddSingleton<IUrlHelperFactory, UrlHelperFactory>();
builder.Services.AddSingleton<IActionContextAccessor, ActionContextAccessor>();
builder.Services.AddScoped<IUrlHelper>(provider =>
{
    var actionContext = provider.GetRequiredService<IActionContextAccessor>().ActionContext;
    return provider.GetRequiredService<IUrlHelperFactory>().GetUrlHelper(actionContext);
});


builder.Services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
builder.Services.AddScoped<IAuthRepository, AuthRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
builder.Services.AddScoped<IJobRepository, JobRepository>();
builder.Services.AddScoped<IApplicationRepository, ApplicationRepository>();


// Add services to the container.
builder.Services.AddTransient<IAuthService, AuthService>();
builder.Services.AddTransient<IEmailService, EmailService>();
builder.Services.AddTransient<IOTPService, OTPService>();
builder.Services.AddTransient<ITokenService, TokenService>();

// Add SignalR services.
builder.Services.AddSignalR();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors("AllowReactApp");
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
// Map your SignalR Hub.
app.MapHub<ServiceHub>("/serviceHub");
app.MapHub<ChatHub>("/chatHub");

app.Run();
