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
    
    @FetchRequest(sortDescriptors: []) private var transactions: FetchedResults<Transaction>
    
    func filterTags(_ tags: Set<Tag>) {
        if tags.isEmpty {
            filteredTransactions.removeAll()
            filteredTransactions = Array(transactions)
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
    
    var body: some View {
        VStack (alignment: .leading) {
            Section( "Filter by Tags") {
                TagsView(selectedTags: $selectedTags)
                    .onChange(of: selectedTags, perform: filterTags)
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
                    }
                    Spacer()
                }

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
