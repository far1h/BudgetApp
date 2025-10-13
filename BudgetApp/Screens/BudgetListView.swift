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
    
    var body: some View {
        List {
            ForEach(categories) { category in
                NavigationLink(destination: Text("Hello World")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(category.title ?? "No Title")
                                .font(.headline)
                            Text("Total: \(category.total.toCurrency())")
                                .font(.subheadline)
                        }
                    }
                }
            }
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

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BudgetListView()
                .environment(\.managedObjectContext, CoreDataManager.preview.context)
        }
    }
}
