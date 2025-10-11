//
//  ContentView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 10/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    // Fetch request to get all budget categories
    @FetchRequest(sortDescriptors: []) private var categories: FetchedResults<BudgetCategory>
    
    @State private var isPresentingAddCategory = false
    private var grandTotal: Double {
        categories.reduce(0) { partialResult, category in
            partialResult + category.total
        }
    }
    
    private func deleteCategory(_ category: BudgetCategory) {
        viewContext.delete(category)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete category: \(error)")
        }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(grandTotal.toCurrency())
                    .fontWeight(.bold)
                BudgetListView(categories: categories, onDelete: deleteCategory)
            }.sheet(isPresented: $isPresentingAddCategory) {
                AddBudgetCategoryView()
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingAddCategory = true
                    } label: {
                        Text("Add Category")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.context)
    }
}


// to add a sheet create the state variable and embed the view in a navigation stack and add the .sheet modifier and a toolbar with a button to present the sheet to the VStack
