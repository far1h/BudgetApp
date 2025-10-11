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
    let onDeleteCategory: (BudgetCategory) -> Void
    let onEditCategory: (BudgetCategory) -> Void
    
    private func deleteCategoryItem(_ offsets: IndexSet) {
        offsets.map { categories[$0] }.forEach(onDeleteCategory)
    }
    
    var body: some View {
        List {
            ForEach(categories) { category in
                NavigationLink(destination: BudgetDetailView(budgetCategory: category)) {
                    HStack {
                        Text(category.title ?? "")
                        Spacer()
                        VStack (alignment: .trailing, spacing: 10) {
                            Text(category.total.toCurrency())
                            Text("\(category.overSpent ? "Overspent" : "Remaining") \(category.remainingBudget.toCurrency())")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .fontWeight(.bold)
                                .foregroundColor(category.overSpent ? .red : .green)
                                .lineLimit(1)
                            
                        }
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button {
                        onEditCategory(category)
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                    
                    Button(role: .destructive) {
                        onDeleteCategory(category)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }   }
            }
        }.overlay {
            if categories.isEmpty {
                Text("No categories available.")
            }
        }
        .listStyle(.plain)

    }
}

//struct BudgetListView_Previews: PreviewProvider {
//    @FetchRequest(sortDescriptors: []) static var categories: FetchedResults<BudgetCategory>
//    static var previews: some View {
//        BudgetListView(categories: categories)
//    }
//}
