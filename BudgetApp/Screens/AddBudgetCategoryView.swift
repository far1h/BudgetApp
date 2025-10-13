//
//  AddBudgetCategoryView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 11/10/2025.
//

import SwiftUI

struct AddBudgetCategoryView: View {
    
    var categoryToEdit: BudgetCategory? = nil
    
    @State private var title: String = ""
    @State private var total: String = ""
    @State private var messages: [String] = []
    
    @Environment(\.managedObjectContext) private var viewContext
    
    private var isFormValid: Bool {
        messages.removeAll()
        
        if title.isEmpty {
            messages.append("Title is required.")
        }
//        else if title.isDuplicate(in: viewContext, excluding: categoryToEdit) {
//            messages.append("Title must be unique.")
//        }
            

        if total.isEmpty {
            messages.append("Total is required.")
        } else if Double(total) == nil || (Double(total) ?? 0) <= 0 {
            messages.append("Total must be a valid number greater than zero.")
        }
        
        return messages.isEmpty
    }
    
    private func saveOrUpdate() {
        if let category = categoryToEdit {
            // Update existing category
            category.title = title
            category.total = Double(total)!
        } else {
            // Add new category
            let newCategory = BudgetCategory(context: viewContext)
            newCategory.title = title
            newCategory.total = Double(total)!
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save category: \(error)")
        }
    }
    
    var body: some View {
            Form {
                Text("Add Budget Category")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                TextField("Title", text: $title)
                TextField("Total", text: $total)
                    .keyboardType(.decimalPad)
                Button {
                    if isFormValid {
                        saveOrUpdate()
                    }
                } label: {
                    Text(categoryToEdit == nil ? "Save Category" : "Update Category")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.top)
                if !messages.isEmpty {
                                            Text("* " + messages.joined(separator: " "))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                   
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let category = categoryToEdit {
                    title = category.title ?? ""
                    total = String(category.total)
                }
                //show a smallr sheet
            }.presentationDetents([.fraction(0.4)])
                
                }
}

struct AddBudgetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetCategoryView()
            .environment(\.managedObjectContext, CoreDataManager.preview.context)
    }
}
