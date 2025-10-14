//
//  ButtonView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 14/10/2025.
//

import SwiftUI

struct ButtonView: View {
    
    let onClick: () -> Void
    let buttonTitle: String
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(buttonTitle)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(.borderedProminent)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding(.top)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(onClick: {}, buttonTitle: "Add Category")
    }
}
