//
//  BudgetListView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI

struct BudgetListView: View {
    
    @State private var isPresentingAddBudgetView: Bool = false
    
    var body: some View {
        List {
                        
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
