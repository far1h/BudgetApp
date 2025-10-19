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
        
        if !UserDefaults.standard.bool(forKey: "hasSeedData") {
            do {
                try seedInitialData(["Food", "Transport", "Entertainment", "Utilities", "Health", "Shopping", "Education", "Travel", "Miscellaneous"])
                UserDefaults.standard.set(true, forKey: "hasSeedData")
                print("Initial data seeded.")
            } catch {
                print("Error seeding initial data: \(error)")
            }
            
        }
    }
    
    func seedInitialData(_ commonTags: [String]) throws {
        for tag in commonTags {
            let newTagItem = Tag(context: context)
            newTagItem.title = tag
        }
        
        try context.save()
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
            try manager.seedInitialData(["Food", "Transport", "Entertainment", "Utilities", "Health", "Shopping", "Education", "Travel", "Miscellaneous"])
            for tags in try context.fetch(Tag.fetchRequest()) as! [Tag] {
                if tags.title == "Food" {
                    transaction2.addToTags(tags)
                    transaction3.addToTags(tags)
                    
                    let foodItems = ["Chicken", "Rice", "Vegetables"]
                    
                    for item in foodItems {
                        let foodTransaction = Transaction(context: context)
                        foodTransaction.dateCreated = Date()
                        foodTransaction.title = item
                        foodTransaction.total = Double.random(in: 10...100)
                        foodTransaction.quantity = Int16.random(in: 1...12)
                        groceries.addToTransactions(foodTransaction)
                        foodTransaction.addToTags(tags)
                    }
                    
                } else if tags.title == "Entertainment" {
                    transaction1.addToTags(tags)
                }
                print("Tag added to transaction: \(tags.title ?? "")")
            }
            
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
