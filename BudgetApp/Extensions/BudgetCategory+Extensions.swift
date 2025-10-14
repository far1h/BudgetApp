//
//  BudgetCategory+Extensions.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 14/10/2025.
//

import Foundation
import CoreData

extension BudgetCategory {
    
    var totalSpent : Double {
        let transactions = self.transactions as? Set<Transaction> ?? []
        return transactions.reduce(0) { $0 + $1.total }
    }
    
    var remainingBudget: Double {
        return total - totalSpent
    }
    
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
