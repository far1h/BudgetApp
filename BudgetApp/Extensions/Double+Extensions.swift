//
//  Double+Extensions.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 10/10/2025.
//

import Foundation

extension Double {
    func toCurrency() -> String {
        return self.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD"))
    }
}
