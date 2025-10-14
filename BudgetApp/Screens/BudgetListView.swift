//
//  BudgetListView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI

struct BudgetListView: View {
    
    @State private var isPresentingAddBudgetView: Bool = false
    @FetchRequest(sortDescriptors: []) private var categories: FetchedResults<BudgetCategory>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private func deleteBudgetCategory(indexSet: IndexSet) {
        indexSet.forEach { index in
            let category = categories[index]
            viewContext.delete(category)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting category: \(error)")
        }
    }
    
    var body: some View {
        // Wrap in NavigationStack to enable NavigationLink previews
        NavigationStack {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        BudgetDetailView(category: category)
                    } label: {
                        HStack {
                            Text(category.title ?? "No Title")
                                .font(.headline)
                            Spacer()
                            Text(category.total.toCurrency())
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteBudgetCategory)
            }.navigationTitle("Budget App")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isPresentingAddBudgetView = true
                        } label: {
                            Text("Add")
                        }
                        
                    }
                }.sheet(isPresented: $isPresentingAddBudgetView) {
                    AddBudgetCategoryView()
                }
        }
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
            .environment(\.managedObjectContext, CoreDataManager.preview.context)
    }
}


