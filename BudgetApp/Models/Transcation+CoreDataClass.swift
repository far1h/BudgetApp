//
//  Transcation+CoreDataClass.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
}

