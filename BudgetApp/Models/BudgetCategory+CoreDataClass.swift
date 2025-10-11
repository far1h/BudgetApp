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
    
    static func transactionsByCategory(category: BudgetCategory) -> NSFetchRequest<Transaction> {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.dateCreated, ascending: false)]
        return request
    }
    
    
}
