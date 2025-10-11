//
//  BudgetDetailView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI
import CoreData

// View details of a budget category
// View and Add a transaction to a budget category
struct BudgetDetailView: View {
    
    let budgetCategory: BudgetCategory
    
    @State private var title: String = ""
    @State private var total: String = ""
    @State private var titleError: String = ""
    @State private var totalError: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var isFormValid: Bool {
        titleError = ""
        totalError = ""
        
        if title.isEmpty {
            titleError = "Title is required."
        }
        if total.isEmpty || Double(total) == nil || (Double(total) ?? 0) <= 0 {
            totalError = "Total must be a valid number greater than zero."
        }
        
        return titleError.isEmpty && totalError.isEmpty
    }
    
    private func addTransaction() {
        let newTransaction = Transaction(context: viewContext)
        newTransaction.title = title
        newTransaction.total = Double(total)!
        
        // available after setting budget category relationship one to many
        budgetCategory.addToTransactions(newTransaction)
        
        do {
            try viewContext.save()
            // Reset form
            title = ""
            total = ""
            print("Transaction added successfully.")
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete transaction: \(error)")
        }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(budgetCategory.title ?? "No Title")
                .font(.largeTitle)
            HStack {
                Text("Budget:")
                Text(budgetCategory.total.toCurrency())
            }
            Form {
                Section("Transactions") {
                    TextField("Title", text: $title)
                    if !titleError.isEmpty {
                        Text(titleError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    TextField("Total", text: $total)
                    if !totalError.isEmpty {
                        Text(totalError)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                HStack {
                    Spacer()
                    Button("Add Transaction") {
                        if isFormValid {
                            addTransaction()
                            
                        }
                    }
                    Spacer()
                }
            }
            // Display summary of the budget category
            BudgetSummaryView(category: budgetCategory)
            
            
            // Display list of transactions for this category
            TransactionListView(category: budgetCategory, onDeleteTransaction: deleteTransaction)
                Spacer()
        }
        .padding()
    }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetDetailView(budgetCategory: BudgetCategory())
//    }
//}
