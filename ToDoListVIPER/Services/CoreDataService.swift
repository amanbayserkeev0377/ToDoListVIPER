import CoreData

final class CoreDataService {
    
    // MARK: - Singleton
    
    static let shared = CoreDataService()
    private init() {}
    
    // MARK: - Core Data Stack
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListVIPER")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData failed to load: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    // MARK: - CRUD Operations
    
    // Create
    func createTask(_ task: ToDoTask, completion: @escaping (Error?) -> Void) {
        let context = newBackgroundContext()
        
        context.perform {
            let entity = TaskEntity(context: context)
            entity.id = Int64(task.id)
            entity.title = task.title
            entity.desc = task.description
            entity.isCompleted = task.isCompleted
            entity.createdAt = task.createdAt
            
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    // Read
    func fetchTasks(completion: @escaping ([ToDoTask], Error?) -> Void) {
        let context = newBackgroundContext()
        
        context.perform {
            let request = TaskEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: false)
            ]
            
            do {
                let entities = try context.fetch(request)
                let tasks = entities.compactMap { $0.toDomain() }
                completion(tasks, nil)
            } catch {
                completion([], error)
            }
        }
    }
    
    // Update
    func updateTask(_ task: ToDoTask, completion: @escaping (Error?) -> Void) {
        let context = newBackgroundContext()
        
        context.perform {
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", task.id)
            
            do {
                let entities = try context.fetch(request)
                guard let entity = entities.first else { return }
                
                entity.title = task.title
                entity.desc = task.description
                entity.isCompleted = task.isCompleted
                
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    // Delete
    func deleteTask(_ task: ToDoTask, completion: @escaping (Error?) -> Void) {
        let context = newBackgroundContext()
        
        context.perform {
            let request = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", task.id)
            
            do {
                let entities = try context.fetch(request)
                guard let entity = entities.first else { return }
                context.delete(entity)
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    // Search
    func searchTasks(query: String, completion: @escaping ([ToDoTask], Error?) -> Void) {
        let context = newBackgroundContext()
        
        context.perform {
            let request = TaskEntity.fetchRequest()
            
            request.predicate = NSPredicate(
                format: "title CONTAINS[cd] %@ OR desc CONTAINS[cd] %@",
                query, query
            )
            // [cd] means case and diacritic insensitive
            
            do {
                let entities = try context.fetch(request)
                let tasks = entities.compactMap { $0.toDomain() }
                completion(tasks, nil)
            } catch {
                completion([], error)
            }
        }
    }
    
    // MARK: - Helpers
    
    func isEmpty(completion: @escaping (Bool) -> Void) {
        let context = newBackgroundContext()
        
        context.perform {
            let request = TaskEntity.fetchRequest()
            let count = (try? context.count(for: request)) ?? 0
            completion(count == 0)
        }
    }
}
