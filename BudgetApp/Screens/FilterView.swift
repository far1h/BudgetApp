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
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var sortOption: SortOption? = nil
    @State private var sortDirection: SortDirection = .asc
    
    @FetchRequest(sortDescriptors: []) private var transactions: FetchedResults<Transaction>
    
    enum SortOption: String, CaseIterable, Identifiable {
        case title = "Title"
        case date = "Date"
        
        var id: String { self.rawValue }
            
        var keyPath: String {
            switch self {
            case .title:
                return "title"
            case .date:
                return "dateCreated"
            }
        }
    }
    
    enum SortDirection: String, CaseIterable, Identifiable {
        case asc = "Ascending"
        case desc = "Descending"
        
        var id: String { self.rawValue }
        
    }
    
    func filterTags(_ tags: Set<Tag>) {
        if tags.isEmpty {
            print("No tags selected, showing all transactions")
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
    
    func filterByDateRange() {
        print("Filtering by date range: \(startDate) to \(endDate)")
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        do {
            filteredTransactions = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching filtered transactions by date range: \(error)")
        }
    }
    
    func performSort() {
        guard let option = sortOption else {
            print("No sort option selected")
            return
        }
        
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: option.keyPath, ascending: sortDirection == .asc)]
        
        do {
            filteredTransactions = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching sorted transactions: \(error)")
        }
    }
    
    var body: some View {
        List  {
            
            Section("Sort") {
                Picker("Sort Options", selection: $sortOption) {
                    Text("None").tag(SortOption?.none)
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option as SortOption?)
                    }
                }
                .onChange (of: sortOption) { _ in
                    performSort()
                }
                    Picker("Sort Direction", selection: $sortDirection) {
                    ForEach(SortDirection.allCases) { direction in
                        Text(direction.rawValue).tag(direction)
                    }
                }
                .onChange (of: sortDirection) { _ in
                    performSort()
                }
                        
            }
            
            Section( "Filter by Tags") {
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, perform: filterTags)
            }
            .listRowSeparator(.hidden)
            
            Section("Filter by Price Range") {
                HStack {
                    TextField("Min", text: $minPrice).keyboardType(.decimalPad)
                        .onChange(of: minPrice) { _ in
                            filterByPriceRange()
                        }
                    TextField("Max", text: $maxPrice)
                        .keyboardType(.decimalPad)
                        .onChange(of: maxPrice) { _ in
                            filterByPriceRange()
                        }
                }.textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .listRowSeparator(.hidden)
            
            Section("Fiter by Title") {
                HStack {
                    TextField("Title contains...", text: $titleFilter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: titleFilter) { _ in
                            filterByTitle()
                        }
                }
            }
            .listRowSeparator(.hidden)
            
            Section("Filter by Date Range") {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    .onChange(of: startDate) { _ in
                        filterByDateRange()
                    }
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    .onChange(of: endDate) { _ in
                        filterByDateRange()
                    }
            }
            .listRowSeparator(.hidden)

            if !filteredTransactions.isEmpty {
                Section("Filtered Transactions") {
                    ForEach(filteredTransactions) { transaction in
                        TransactionCellView(transaction: transaction)
                    }
                }
//                .listRowSeparator(.hidden)
                .listRowBackground(Color(.systemGray6))
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
            .padding(.top, 8)
            
            
            
            
            
        }
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
