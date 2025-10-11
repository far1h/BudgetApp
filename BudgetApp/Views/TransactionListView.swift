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
    let onDeleteTransaction: (Transaction) -> Void
    
    init(category: BudgetCategory, onDeleteTransaction: @escaping (Transaction) -> Void) {
        _transactions = FetchRequest(fetchRequest: BudgetCategory.transactionsByCategory(category: category))
        self.onDeleteTransaction = onDeleteTransaction
    }
    
    private func deleteTransactionItem(_ offsets: IndexSet) {
        offsets.map { transactions[$0] }.forEach(onDeleteTransaction)
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
            .onDelete(perform: deleteTransactionItem)
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
