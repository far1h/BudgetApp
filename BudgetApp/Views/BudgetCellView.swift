//
//  BudgetCellView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 14/10/2025.
//

import SwiftUI

struct BudgetCellView: View {
    
    let category: BudgetCategory
    
    var body: some View {
        HStack {
            Text(category.title ?? "No Title")
                .font(.headline)
            Spacer()
            Text(category.total.toCurrency())
                .font(.subheadline)
        }
    }
}
