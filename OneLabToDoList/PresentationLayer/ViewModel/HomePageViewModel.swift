//
//  HomePageViewModel.swift
//  OneLabToDoList
//
//  Created by Мирас on 1/6/21.
//

import Foundation

final class HomePageViewModel {
    
    var categoryArray = [Category]()
    
    func createNewCategory(name: String) {
        categoryArray.append(CoreDataManager.sharedInstance.createNewCategory(name: name))
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func fetchCategories() {
        categoryArray = CoreDataManager.sharedInstance.fetchCategory()!
    }
    
    func removeCategories(at indexPath: Int) {
        CoreDataManager.sharedInstance.delete(categoryArray[indexPath])
        categoryArray.remove(at: indexPath)
    }
    
    func updateCategoryName(at indexPath: Int, with text: String) {
        categoryArray[indexPath].name = text
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func calculateWidth(screen width: Double) -> Int{
        return Int(width / Constants.Numbers.screenDivisionNumber)
    }
}
