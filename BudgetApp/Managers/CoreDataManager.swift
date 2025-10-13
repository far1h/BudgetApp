//
//  CoreDataManager.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 10/10/2025.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "BudgetModel")

        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    static var preview: CoreDataManager = {
        let manager = CoreDataManager(inMemory: true)
        
        let context = manager.context
        
        for i in 0..<5 {
            let category = BudgetCategory(context: context)
            category.dateCreated = Date()
            category.title = "Category \(i)"
            category.total = Double((i + 1) * 100)
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save preview data: \(error)")
        }
        
        return manager
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
