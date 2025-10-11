//
//  TransactionListView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI
import CoreData

struct TransactionListView: View {
    
    @FetchRequest var transactions: FetchedResults<Transaction>
    
    init(category: BudgetCategory) {
        _transactions = FetchRequest(fetchRequest: BudgetCategory.transactionsByCategory(category: category))
    }
    
    var body: some View {
        List {
            ForEach (transactions) { transaction in
                HStack {
                    Text(transaction.title ?? "")
                    Spacer()
                    Text(transaction.total.toCurrency())
                }
            }
            if transactions.isEmpty {
                Text("No transactions available.")
            }
        }.listStyle(.plain)
    }
}

//struct TransactionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionListView()
//    }
//}
