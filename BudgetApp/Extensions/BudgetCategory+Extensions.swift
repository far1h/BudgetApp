//
//  BudgetCategory+Extensions.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 14/10/2025.
//

import Foundation
import CoreData

extension BudgetCategory {
    
    static func exists(title: String, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest = BudgetCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Error checking existence of category: \(error)")
            return false
        }
    }
}
