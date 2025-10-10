//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 10/10/2025.
//

import SwiftUI

@main
struct BudgetAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inject the managed object context into the environment
                .environment(\.managedObjectContext, CoreDataManager.shared.context)
        }
    }
}
