//
//  ContentView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 10/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresentingAddCategory = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }.sheet(isPresented: $isPresentingAddCategory) {
                AddBddugetCategoryView()
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingAddCategory = true
                    } label: {
                        Text("Add Category")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// to add a sheet create the state variable and embed the view in a navigation stack and add the .sheet modifier and a toolbar with a button to present the sheet to the VStack
