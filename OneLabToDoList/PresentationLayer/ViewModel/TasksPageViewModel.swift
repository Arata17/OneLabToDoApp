//
//  TasksPageViewModel.swift
//  OneLabToDoList
//
//  Created by Мирас on 1/8/21.
//

import UIKit

final class TasksPageViewModel {
    
    var items = [Item]()
    var didEndTimer: () -> Void = { }
    
    private var timer: Timer? = nil
    private var deletedItem: Item?
    private var clearItem: Item?
    private var timerCount = 0
    
    func createNewTask(title: String, category: Category) {
        items.append(CoreDataManager.sharedInstance.createNewTasks(title: title, status: false, parentCategory: category))
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func fetchTasks(from category: Category) {
        items = CoreDataManager.sharedInstance.fetchItems(from: category)!
    }
    
    func removeTasks(at indexPath: Int) {
        deletedItem = CoreDataManager.sharedInstance.createNewTasks(title: items[indexPath].title!,
                                                                    status: items[indexPath].done,
                                                                    parentCategory: items[indexPath].parentCategory!)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
                self.timerCount += 1
                if self.timerCount == 5 {
                    timer.invalidate()
                    self.timerCount = 0
                    self.didEndTimer()
                    CoreDataManager.sharedInstance.delete(self.deletedItem!)
                    self.deletedItem = self.clearItem
                }
            }
        CoreDataManager.sharedInstance.delete(self.items[indexPath])
        self.items.remove(at: indexPath)
    }
    
    func updateTask(at indexPath: Int, with text: String) {
        items[indexPath].title = text
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func taskStatusDidChange(at indexPath: Int) {
        items[indexPath].done = !items[indexPath].done
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func undoTaskDelition() {
        timer?.invalidate()
        timerCount = 0
        items.append(deletedItem!)
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func getTextColor(for indexPath: Int) -> UIColor {
        return !items[indexPath].done ? .black : .gray
    }
}
