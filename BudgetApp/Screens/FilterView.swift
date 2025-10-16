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
    @State private var minPrice: String = ""
    @State private var maxPrice: String = ""
    
    
    @FetchRequest(sortDescriptors: []) private var transactions: FetchedResults<Transaction>
    
    func filterTags(_ tags: Set<Tag>) {
        if tags.isEmpty {
            print("No tags selected, showing all transactions")
            filteredTransactions = Array(transactions)
            return
        }
        let tagTitles = tags.compactMap { $0.title }
        
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY tags.title IN %@", tagTitles)
        
        do {
            filteredTransactions = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching filtered transactions: \(error)")
        }
        
    }
    
    func filterByPriceRange() {
        guard let minPrice = Double(minPrice), let maxPrice = Double(maxPrice), minPrice <= maxPrice else {
            print("Invalid price range")
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
                    TextField("Min", text: $minPrice).keyboardType(.decimalPad)
                    TextField("Max", text: $maxPrice)
                        .keyboardType(.decimalPad)
                    Button("Apply") {
                        filterByPriceRange()
                    }
                }.textFieldStyle(RoundedBorderTextFieldStyle())
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
                    minPrice = ""
                    maxPrice = ""
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
