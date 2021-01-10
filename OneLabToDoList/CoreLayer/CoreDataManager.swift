import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    func appDelegate()->AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func managedObjectContext() -> NSManagedObjectContext {
        return self.appDelegate().persistentContainer.viewContext
    }
    
    func createNewTasks(title: String, status: Bool, parentCategory: Category) -> Item {
        let newTask = Item(context: managedObjectContext())
        newTask.title = title
        newTask.done = status
        newTask.parentCategory = parentCategory
        return newTask
    }
    
    func createNewCategory(name: String) -> Category {
        let newCategory = Category(context: managedObjectContext())
        newCategory.name = name
        return newCategory
    }
    
    func saveContext() {
        do{
            try self.managedObjectContext().save()
        } catch {
            print(error)
        }
    }
    
    func fetchItems(from category: Category) -> [Item]? {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)
        request.predicate = categoryPredicate
        do{
            let items = try managedObjectContext().fetch(request)
            return items
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchCategory() -> [Category]? {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            let category = try managedObjectContext().fetch(request)
            return category
        } catch {
            print(error)
            return nil
        }
    }
    
    func delete(_ item: NSManagedObject) {
        managedObjectContext().delete(item)
        if managedObjectContext().hasChanges {
            do {
                try managedObjectContext().save()
            } catch {
                managedObjectContext().rollback()
            }
        }
    }
}
