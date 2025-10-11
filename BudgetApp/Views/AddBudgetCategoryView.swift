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
    @State private var total: Double = 100
    @State private var messages: [String] = []
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    private var isFormValid: Bool {
        messages.removeAll()
        
        if title.isEmpty {
            messages.append("Title is required.")
        }
        if total <= 0 {
            messages.append("Total must be greater than zero.")
        }
        
        return messages.isEmpty
    }
    
    private func saveOrUpdate() {
        if let category = categoryToEdit {
            // Update existing category
            category.title = title
            category.total = total
        } else {
            // Add new category
            let newCategory = BudgetCategory(context: viewContext)
            newCategory.title = title
            newCategory.total = total
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Failed to save category: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                Slider(value: $total, in: 0...10000000, step: 50000) {
                    Text("Total")
                } minimumValueLabel: {
                    Text(0.toCurrency())
                } maximumValueLabel: {
                    Text(10000000.toCurrency())
                }
                Text(total.toCurrency())
                    .frame(maxWidth: .infinity, alignment: .center)
                ForEach(messages, id: \.self) { message in
                    Text(message)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .onAppear {
                if let category = categoryToEdit {
                    title = category.title ?? ""
                    total = category.total
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isFormValid {
                            saveOrUpdate()
                        }
                    }
                }
            }
        }
    }
}

struct AddBudgetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetCategoryView()
    }
}
