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
    @State private var titleFilter: String = ""
    
    
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
    
    func filterByTitle() {
        guard !titleFilter.isEmpty else {
            print("Title filter must be set")
            return
        }
        
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", titleFilter)
        do {
            filteredTransactions = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching filtered transactions by title: \(error)")
        }
    }
    
    var body: some View {
            List {
                Section( "Filter by Tags") {
                    TagsView(selectedTags: $selectedTags)
                        .onChange(of: selectedTags, perform: filterTags)
                }
                .listRowSeparator(.hidden)

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
                .listRowSeparator(.hidden)

                Section("Fiter by Title") {
                    HStack {
                        TextField("Title contains...", text: $titleFilter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button("Apply") {
                            filterByTitle()
                        }
                    }
                }
                .listRowSeparator(.hidden)

                    ForEach(filteredTransactions) { transaction in
                        TransactionCellView(transaction: transaction)
                    }

                
                HStack {
                    Spacer()
                    Button("Show All") {
                        selectedTags.removeAll()
                        minPrice = ""
                        maxPrice = ""
                        filterByPriceRange()
                        filteredTransactions.removeAll()
                        filteredTransactions = Array(transactions)
                    }
                    Spacer()
                }
                .listRowSeparator(.hidden)

                
                
            }.padding()
            .listStyle(.plain)
            .buttonStyle(.borderless)
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environment(\.managedObjectContext, CoreDataManager.preview.context)
    }
}
