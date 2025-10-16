//
//  FilterView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 15/10/2025.
//

import SwiftUI

struct FilterView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedTags: Set<Tag> = []
    @State private var filteredTransactions: [Transaction] = []
    @State private var minPrice: Double?
    @State private var maxPrice: Double?
    
    
    @FetchRequest(sortDescriptors: []) private var transactions: FetchedResults<Transaction>
    
    func filterTags(_ tags: Set<Tag>) {
        if tags.isEmpty {
            return
        }
        let tagTitles = tags.compactMap { $0.title }
        
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY tags.title IN %@", tagTitles)
        
        do {
            filteredTransactions = try viewContext.fetch(fetchRequest)
            print("Filtered Transactions: \(filteredTransactions)")
        } catch {
            print("Error fetching filtered transactions: \(error)")
        }
        
    }
    
    func filterByPriceRange() {
        guard let minPrice = minPrice, let maxPrice = maxPrice else {
            print("Min and Max price must be set")
            return
        }
        
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "total >= %f AND total <= %f", minPrice, maxPrice)
        do {
            filteredTransactions = try viewContext.fetch(fetchRequest)
            print("Filtered Transactions by Price Range: \(filteredTransactions)")
        } catch {
            print("Error fetching filtered transactions by price range: \(error)")
        }
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            Section( "Filter by Tags") {
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, perform: filterTags)
            }
            Section("Filter by Price Range") {
                HStack {
                    TextField("Min", value: $minPrice, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Max", value: $maxPrice, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Apply") {
                        filterByPriceRange()
                    }
                }
            }
            List {
                ForEach(filteredTransactions) { transaction in
                    TransactionCellView(transaction: transaction)
                }
            }.listStyle(.plain)
            Spacer()
            HStack {
                Spacer()
                Button("Clear Filters") {
                    selectedTags.removeAll()
                    filterByPriceRange()
                    filteredTransactions.removeAll()
                    filteredTransactions = Array(transactions)
                }
                Spacer()
            }
            
            
        }.padding()
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environment(\.managedObjectContext, CoreDataManager.preview.context)
    }
}
