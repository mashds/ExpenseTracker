//
//  ExpenseRepository.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation

final class ExpenseRepository: ExpenseRepositoryProtocol {

    private let api: ExpenseAPI

    init(api: ExpenseAPI) {
        self.api = api
    }

    func getExpenses() async throws -> [Expense] {
        try await api.fetchExpenses()
    }

    func addExpense(amount: Double, currency: String, category: ExpenseCategory, note: String?, date: Date) async throws -> Expense {
        let expense = Expense(
            id: UUID().uuidString,
            amount: amount,
            currency: currency,
            category: category,
            note: note,
            date: date,
            createdAt: Date()
        )

        return try await api.addExpense(expense)
    }

    func deleteExpense(id: String) async throws {
        try await api.deleteExpense(id: id)
    }

    func filterExpenses(category: ExpenseCategory?, from: Date?, to: Date?) async throws -> [Expense] {
        try await api.filterExpenses(category: category, from: from, to: to)
    }

    func getSummary() async throws -> [CategorySummary] {
        try await api.fetchSummary()
    }
}
