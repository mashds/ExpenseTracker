//
//  ExpenseListViewModel.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation
import Combine

@MainActor
final class ExpenseListViewModel: ObservableObject {

    @Published var expenses: [Expense] = []
    @Published var summaries: [CategorySummary] = []

    @Published var selectedCategory: ExpenseCategory?
    @Published var fromDate: Date?
    @Published var toDate: Date?

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let repository: ExpenseRepositoryProtocol

    init(repository: ExpenseRepositoryProtocol) {
        self.repository = repository
    }

    func loadExpenses() async {
        isLoading = true
        errorMessage = nil

        do {
            expenses = try await repository.getExpenses()
        } catch {
            errorMessage = "Unable to load expenses. Please try again."
            showError = true
        }

        isLoading = false
    }

    func addExpense(amountText: String, category: ExpenseCategory, note: String, date: Date) async {
        guard let amount = Double(amountText), amount > 0 else {
            errorMessage = "Please enter a valid amount."
            showError = true
            return
        }

        do {
            let newExpense = try await repository.addExpense(
                amount: amount,
                currency: "LKR",
                category: category,
                note: note.isEmpty ? nil : note,
                date: date
            )

            expenses.insert(newExpense, at: 0)
        } catch {
            errorMessage = "Unable to add expense. Please try again."
            showError = true
        }
    }

    func deleteExpense(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let expense = expenses[index]

                do {
                    try await repository.deleteExpense(id: expense.id)
                    expenses.remove(at: index)
                } catch {
                    errorMessage = "Unable to delete expense."
                    showError = true
                }
            }
        }
    }

    func applyFilter() async {
        isLoading = true

        do {
            expenses = try await repository.filterExpenses(
                category: selectedCategory,
                from: fromDate,
                to: toDate
            )
        } catch {
            errorMessage = "Unable to filter expenses."
            showError = true
        }

        isLoading = false
    }

    func loadSummary() async {
        do {
            summaries = try await repository.getSummary()
        } catch {
            errorMessage = "Unable to load spending summary."
            showError = true
        }
    }
}
