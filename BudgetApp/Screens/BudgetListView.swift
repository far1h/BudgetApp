//
//  BudgetListView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI

struct BudgetListView: View {
    
    @State private var isPresentingFilterView: Bool = false
    @State private var isPresentingAddBudgetView: Bool = false
    @FetchRequest(sortDescriptors: []) private var categories: FetchedResults<BudgetCategory>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private func deleteBudgetCategory(indexSet: IndexSet) {
        indexSet.forEach { index in
            let category = categories[index]
            deleteCategoryItem(category)
        }
    }
    
    private func deleteCategoryItem(_ category: BudgetCategory) {
        viewContext.delete(category)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting category: \(error.localizedDescription)")
        }
    }          
            
    
    var body: some View {
        // Wrap in NavigationStack to enable NavigationLink previews
        NavigationStack {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        BudgetDetailView(category: category, onDeleteCategory: deleteCategoryItem)
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
                .overlay(alignment: .bottom, content: {
                    Button("Filter") {
                        isPresentingFilterView = true
                    }.buttonStyle(.borderedProminent)
                })
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
                .sheet(isPresented: $isPresentingFilterView) {
                    FilterView()
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


