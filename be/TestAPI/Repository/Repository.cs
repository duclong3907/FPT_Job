using Microsoft.EntityFrameworkCore;
using System;
using TestAPI.Contextes;

namespace TestAPI.Repository
{
    public class Repository<T> : IRepository<T> where T : class
    {
        private readonly DbSet<T> _dbSet;
        private readonly AuthDemoDbContext _myDbContext;
        public Repository(AuthDemoDbContext myDbContext)
        {
            _dbSet = myDbContext.Set<T>();
            _myDbContext = myDbContext;
        }

        public async Task<T> Add(T entity)
        {
            await _dbSet.AddAsync(entity);
            await _myDbContext.SaveChangesAsync();
            return entity;
        }

        public async Task Delete(T id)
        {
            _dbSet.Remove(id);
            await _myDbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<T>> GetAll()
        {
            return await _dbSet.ToListAsync();
        }

        public async Task<T> GetById(int id)
        {
            return await _dbSet.FindAsync(id);
        }

        public async Task<T> GetByNotSoftDeletedId(int id)
        {
            return await _dbSet.FirstOrDefaultAsync(x => EF.Property<int>(x, "Id") == id && EF.Property<int>(x, "Deleted") == 0);
        }

        public async Task<IEnumerable<T>> GetAllNotSoftDeleted()
        {
            return await _dbSet.Where(x => EF.Property<int>(x, "Deleted") == 0).ToListAsync();
        }

        public async Task Update(T entity)
        {
            _dbSet.Attach(entity);
            _myDbContext.Entry(entity).State = EntityState.Modified;
            await _myDbContext.SaveChangesAsync();
        }
    }
}
