//
//  TransactionCellView.swift
//  BudgetApp
//
//  Created by Farih Muhammad on 15/10/2025.
//

import SwiftUI

struct TransactionCellView: View {
    
    let transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(transaction.title ?? "")
                Text("\(transaction.quantity)")
                Spacer()
                Text(transaction.totalAmount.toCurrency())
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach (Array(transaction.tags as? Set<Tag> ?? [])) { tag in
                        Text(tag.title ?? "No Title")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}


