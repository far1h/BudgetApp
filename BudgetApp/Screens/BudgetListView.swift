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
            
    private var totalBudget: Double {
        categories.reduce(0) { $0 + $1.total }
    }
    
    var body: some View {
        // Wrap in NavigationStack to enable NavigationLink previews
        NavigationStack {
            VStack {
                if categories.isEmpty {
                    Image(systemName: "chart.pie.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.blue.gradient)
                        .padding()
                    Text("No Budget Categories. Please add a budget category.")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                } else {
                    List {
                        VStack (alignment: .center, spacing: 5) {
                            Text("Total Budget")
                                .font(.title2)
                                .bold()
                            Text(totalBudget.toCurrency())
                                .font(.largeTitle)
                                .bold()
                                .padding(.bottom, 5)
                        }.frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                        Section("Budget Categories") {
                            ForEach(categories) { category in
                                NavigationLink {
                                    BudgetDetailView(category: category, onDeleteCategory: deleteCategoryItem)
                                } label: {
                                    HStack {
                                        Text(category.title ?? "No Title")
                                        Spacer()
                                        Text(category.total.toCurrency())
                                    }
                                }
                            }.onDelete(perform: deleteBudgetCategory)
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
                .sheet(isPresented: $isPresentingFilterView) {
                    FilterView()
                }
        }.overlay(alignment: .bottom, content: {
            Button("Filter") {
                isPresentingFilterView = true
            }.buttonStyle(.borderedProminent)
        })
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
            .environment(\.managedObjectContext, CoreDataManager.preview.context)
    }
}


