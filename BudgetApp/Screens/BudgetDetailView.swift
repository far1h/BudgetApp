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
    
    let category: BudgetCategory
    
    @State private var title: String = ""
    @State private var total: String = ""
    @State private var messages: [String] = []
    
    @FetchRequest(sortDescriptors: []) private var transactions: FetchedResults<Transaction>
    
    init(category: BudgetCategory) {
        self.category = category
        _transactions = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "category == %@", category))
            
        }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var isFormValid: Bool {
        messages.removeAll()
        
        if title.isEmpty {
            messages.append("Title is required.")
        }
        if total.isEmpty || Double(total) == nil || (Double(total) ?? 0) <= 0 {
            messages.append("Total must be a valid number greater than zero.")
        }
        
        return messages.isEmpty
    }
    
    private func addTransaction() {
        guard isFormValid else { return }
        let newTransaction = Transaction(context: viewContext)
        newTransaction.title = title
        newTransaction.total = Double(total)!
        newTransaction.dateCreated = Date()
        
        // available after setting budget category relationship one to many
        category.addToTransactions(newTransaction)
        
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

            Form {
                Section("New Expense") {
                    TextField("Title", text: $title)
                    TextField("Total", text: $total)
                        .keyboardType(.decimalPad)
                    ButtonView(onClick: addTransaction, buttonTitle: "Add Expense")
                    if !messages.isEmpty {
                        FormErrorView(messages: messages)
                    }
                }
                Section("Expenses") {
                    List (transactions) { transaction in
                        HStack {
                            Text(transaction.title ?? "")
                            Spacer()
                            Text(transaction.total.toCurrency())
                        }
                    }
                }
            }.navigationTitle(category.title ?? "Budget Detail")
        }
}


struct BudgetDetailViewContainer: View {

    @FetchRequest(sortDescriptors: []) private var categories: FetchedResults<BudgetCategory>
    
    var body: some View {
        BudgetDetailView(category: categories[1])
    }
}

// use container to preview
struct BudgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BudgetDetailViewContainer()
                .environment(\.managedObjectContext, CoreDataManager.preview.context)
        }
    }
}
