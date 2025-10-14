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
        // Wrap in NavigationStack to enable NavigationLink previews
        NavigationStack {
            List {
                ForEach(categories) { category in
                    NavigationLink {
                        BudgetDetailView(category: category)
                    } label: {
                        BudgetCellView(category: category)
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
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
            .environment(\.managedObjectContext, CoreDataManager.preview.context)
    }
}


