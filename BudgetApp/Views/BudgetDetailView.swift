//
//  BudgetDetailView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI

// View details of a budget category
struct BudgetDetailView: View {
    
    let budgetCategory: BudgetCategory
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                VStack (alignment: .leading) {
                    Text(budgetCategory.title ?? "No Title")
                        .font(.largeTitle)
                    HStack {
                        Text("Budget:")
                        Text(budgetCategory.total.toCurrency())
                    }.fontWeight(.bold)
                }
            }
            Spacer()
        }
    }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetDetailView(budgetCategory: BudgetCategory())
//    }
//}
