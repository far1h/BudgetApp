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
        
        // Create sample data for preview
        let entertainment = BudgetCategory(context: context)
        entertainment.dateCreated = Date()
        entertainment.title = "Entertainment"
        entertainment.total = 200.0
        
        let groceries = BudgetCategory(context: context)
        groceries.dateCreated = Date()
        groceries.title = "Groceries"
        groceries.total = 300.0
        
        let transaction1 = Transaction(context: context)
        transaction1.dateCreated = Date()
        transaction1.title = "Movie"
        transaction1.total = 50.0
        entertainment.addToTransactions(transaction1)
        
        let transaction2 = Transaction(context: context)
        transaction2.dateCreated = Date()
        transaction2.title = "Apple"
        transaction2.total = 30.0
        groceries.addToTransactions(transaction2)
        
        let transaction3 = Transaction(context: context)
        transaction3.dateCreated = Date()
        transaction3.title = "Banana"
        transaction3.total = 20.0
        groceries.addToTransactions(transaction3)
        
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
