//
//  ExpenseRowView.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import SwiftUI

struct ExpenseRowView: View {

    let expense: Expense

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(expense.category.displayName)
                    .font(.headline)

                if let note = expense.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(DateFormatterHelper.displayDate.string(from: expense.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(CurrencyFormatterHelper.format(amount: expense.amount, currency: expense.currency))
                .font(.headline)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(expense.category.displayName), \(CurrencyFormatterHelper.format(amount: expense.amount, currency: expense.currency)), \(expense.note ?? "No note"), date \(DateFormatterHelper.displayDate.string(from: expense.date))"
        )
    }
}
