//
//  Transaction+Extensions.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 17/10/2025.
//

import Foundation

extension Transaction {
    var totalAmount: Double {
        return total * Double(quantity)
    }
}
