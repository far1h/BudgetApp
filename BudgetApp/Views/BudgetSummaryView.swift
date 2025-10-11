//
//  BudgetSummaryView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI

struct BudgetSummaryView: View {
    
    @ObservedObject var category: BudgetCategory
    
    var body: some View {
        VStack {
            Text("\(category.overSpent ? "Overspent" : "Remaining") \(category.remainingBudget.toCurrency())")
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)
                .foregroundColor(category.overSpent ? .red : .green)
        }
    }
}

//struct BudgetSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetSummaryView()
//    }
//}
