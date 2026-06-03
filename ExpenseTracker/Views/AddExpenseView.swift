//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import SwiftUI

struct AddExpenseView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ExpenseListViewModel

    @State private var amount = ""
    @State private var selectedCategory: ExpenseCategory = .food
    @State private var note = ""
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ExpenseCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    TextField("Note", text: $note)

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await viewModel.addExpense(
                                amountText: amount,
                                category: selectedCategory,
                                note: note,
                                date: date
                            )
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
