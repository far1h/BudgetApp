//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 10/10/2025.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
    
    // properties to track remaining budget and over budget status
    
    var overSpent: Bool {
        remainingBudget < 0
    }
    
    var transactionsTotal: Double {
        transactionsArray.reduce(0) { $0 + $1.total }
    }
    
    var remainingBudget: Double {
        self.total - transactionsTotal
    }
    
    private var transactionsArray: [Transaction] {
        // get transactions or return empty array
        guard let transactions = transactions else { return [] }
        // convert to array and sort by date created
        let array = transactions.allObjects as! [Transaction]
        return array.sorted { $0.dateCreated! > $1.dateCreated! }
    }
    
    static func transactionsByCategory(category: BudgetCategory) -> NSFetchRequest<Transaction> {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.dateCreated, ascending: false)]
        return request
    }
    
    
}
