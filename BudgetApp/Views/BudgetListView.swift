//
//  BudgetListView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI

struct BudgetListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let categories: FetchedResults<BudgetCategory>
    
    var body: some View {
        List {
            ForEach(categories) { category in
                HStack {
                    Text(category.title ?? "")
                    Spacer()
                    Text(category.total.toCurrency())
                }
            }
        }.overlay {
            if categories.isEmpty {
                Text("No categories available.")
            }
        }
    }
}

struct BudgetListView_Previews: PreviewProvider {
    @FetchRequest(sortDescriptors: []) static var categories: FetchedResults<BudgetCategory>
    static var previews: some View {
        BudgetListView(categories: categories)
    }
}
