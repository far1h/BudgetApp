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
        
    private func deleteTransaction(_ indexSet: IndexSet) {
        // receive index set of the item to be deleted
        // for each value in the index set, find the transaction in the fetched results and delete it from the context
        indexSet.forEach { index in
            let transaction = transactions[index]
            viewContext.delete(transaction)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete transaction: \(error)")
        }
    }
    
    var body: some View {

            Form {
                VStack {
                    Text(category.total.toCurrency())
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                    Text("Remaining: \(category.remainingBudget.toCurrency())")
                        .foregroundColor(category.remainingBudget < 0 ? .red : .green)
                        .bold()
                }
                .listRowSeparator(.hidden)
                
                
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
                    List {
                            ForEach (transactions) { transaction in
                                HStack {
                                    Text(transaction.title ?? "")
                                    Spacer()
                                    Text(transaction.total.toCurrency())
                                }
                            }.onDelete(perform: deleteTransaction)
                            HStack {
                                Text("Total Spent")
                                    .bold()
                                Spacer()
                                Text(category.totalSpent.toCurrency())
                                    .bold()
                            }
                            .listRowBackground(Color.gray.opacity(0.125))
                        
                    }
                }
            }.navigationTitle(category.title ?? "Budget Detail")
        }
}


struct BudgetDetailViewContainer: View {

    @FetchRequest(sortDescriptors: []) private var categories: FetchedResults<BudgetCategory>
    
    var body: some View {
        BudgetDetailView(category: categories.first(where: { $0.title == "Groceries" }) ?? categories[0])
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
