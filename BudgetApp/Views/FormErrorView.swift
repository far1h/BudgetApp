//
//  FormErrorView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 14/10/2025.
//

import SwiftUI

struct FormErrorView: View {
    
    let messages: [String]
    
    var body: some View {
        Text("* " + messages.joined(separator: " "))
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

struct FormErrorView_Previews: PreviewProvider {
    static var previews: some View {
        FormErrorView(messages: ["Title is required.", "Total must be greater than zero."])
    }
}
