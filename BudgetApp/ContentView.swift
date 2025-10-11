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
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(categories) { category in
                        VStack(alignment: .leading) {
                            Text(category.title ?? "")
                                .font(.headline)
                            Text(category.total.toCurrency())
                                .font(.subheadline)
                        }
                    }.onDelete { indexSet in
                        indexSet.forEach { index in
                            let category = categories[index]
                            viewContext.delete(category)
                            do {
                                try viewContext.save()
                            } catch {
                                print("Failed to delete category: \(error)")
                            }
                        }
                    }
                }
            }.sheet(isPresented: $isPresentingAddCategory) {
                AddBddugetCategoryView()
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
        ContentView()
    }
}


// to add a sheet create the state variable and embed the view in a navigation stack and add the .sheet modifier and a toolbar with a button to present the sheet to the VStack
