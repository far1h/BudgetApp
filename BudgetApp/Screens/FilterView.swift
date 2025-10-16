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
    // Date start of the day
    @State private var startDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var endDate: Date =
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
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
        
    func performFilter(){
        
        print("Performing filter with:")
        
        var predicates: [NSPredicate] = []
        var sortDescriptors: [NSSortDescriptor] = []
        
        // Tags Filter
        if !selectedTags.isEmpty {
            let tagTitles = selectedTags.compactMap { $0.title }
            let tagsPredicate = NSPredicate(format: "ANY tags.title IN %@", tagTitles)
            predicates.append(tagsPredicate)
            print("Selected Tags: \(tagTitles)")
        }
        
        // Price Range Filter
        if let minPriceValue = Double(minPrice), let maxPriceValue = Double(maxPrice), minPriceValue <= maxPriceValue {
            let pricePredicate = NSPredicate(format: "total >= %f AND total <= %f", minPriceValue, maxPriceValue)
            predicates.append(pricePredicate)
        }
        
        // Title Filter
        if !titleFilter.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", titleFilter)
            predicates.append(titlePredicate)
        }
        
        // Date Range Filter
        let datePredicate = NSPredicate(format: "dateCreated >= %@ AND dateCreated <= %@", startDate as NSDate, endDate as NSDate)
        predicates.append(datePredicate)
        
        // Sort Descriptors
        if let option = sortOption {
            let sortDescriptor = NSSortDescriptor(key: option.keyPath, ascending: sortDirection == .asc)
            sortDescriptors.append(sortDescriptor)
        }
        
        // Combine all predicates
        
        let fetchRequest = Transaction.fetchRequest()
        if !predicates.isEmpty {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        if !sortDescriptors.isEmpty {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        print("Fetch Request Predicate: \(String(describing: fetchRequest.predicate))")
        
        // Fetch filtered transactions
        
        do {
            filteredTransactions = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching filtered transactions: \(error)")
        }
    }
    
        
    var body: some View {
        NavigationStack {
            List  {
                
                Section("Sort") {
                    Picker("Sort Options", selection: $sortOption) {
                        Text("None").tag(SortOption?.none)
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option as SortOption?)
                        }
                    }
                        Picker("Sort Direction", selection: $sortDirection) {
                        ForEach(SortDirection.allCases) { direction in
                            Text(direction.rawValue).tag(direction)
                        }
                    }
                }
                
                Section( "Filter by Tags") {
                    TagsView(selectedTags: $selectedTags)
                }
                .listRowSeparator(.hidden)
                
                Section("Filter by Price Range") {
                    HStack {
                        TextField("Min", text: $minPrice).keyboardType(.decimalPad)
                        TextField("Max", text: $maxPrice)
                            .keyboardType(.decimalPad)
                    }.textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .listRowSeparator(.hidden)
                
                Section("Fiter by Title") {
                    HStack {
                        TextField("Title contains...", text: $titleFilter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .listRowSeparator(.hidden)
                
                Section("Filter by Date Range") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                .listRowSeparator(.hidden)
                
                HStack {
                    
                    Button {
                        performFilter()
                    } label: {
                        Text("Apply Filters")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        // Clear all filters
                        selectedTags.removeAll()
                        minPrice = ""
                        maxPrice = ""
                        titleFilter = ""
                        startDate = Calendar.current.startOfDay(for: Date())
                        endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date()
                        sortOption = nil
                        sortDirection = .asc
                        filteredTransactions = Array(transactions)
                    } label: {
                        Text("Clear Filters")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .listRowSeparator(.hidden)
                .padding(.top, 16)
                
                if !filteredTransactions.isEmpty {
                    Section("Filtered Transactions") {
                        ForEach(filteredTransactions) { transaction in
                            TransactionCellView(transaction: transaction)
                        }
                    }
    //                .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemGray6))
                }
            }
            .onAppear {
                // Initialize filteredTransactions with all transactions on appear
                filteredTransactions = Array(transactions)
            }
        .listStyle(.plain)
        .navigationTitle("Filter Transactions")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
            .environment(\.managedObjectContext, CoreDataManager.preview.context)
    }
}
