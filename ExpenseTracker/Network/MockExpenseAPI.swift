//
//  MockExpenseAPI.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation

final class MockExpenseAPI: ExpenseAPI {
    
    private let localStore: ExpenseLocalStoreProtocol
    private var expenses: [Expense]
    
    init(localStore: ExpenseLocalStoreProtocol = ExpenseLocalStore()) {
        self.localStore = localStore

        let savedExpenses = localStore.loadExpenses()

        if savedExpenses.isEmpty {
            self.expenses = Self.defaultExpenses
            localStore.saveExpenses(Self.defaultExpenses)
        } else {
            self.expenses = savedExpenses
        }
    }

    private static let defaultExpenses: [Expense] = [
        Expense(
            id: UUID().uuidString,
            amount: 1200,
            currency: "LKR",
            category: .food,
            note: "Lunch",
            date: Date(),
            createdAt: Date()
        ),
        Expense(
            id: UUID().uuidString,
            amount: 500,
            currency: "LKR",
            category: .transport,
            note: "Bus",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            createdAt: Date()
        ),
        Expense(
            id: UUID().uuidString,
            amount: 3500,
            currency: "LKR",
            category: .bills,
            note: "Electricity bill",
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            createdAt: Date()
        )
    ]

    func fetchExpenses() async throws -> [Expense] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return expenses.sorted { $0.date > $1.date }
    }

    func addExpense(_ expense: Expense) async throws -> Expense {
        try await Task.sleep(nanoseconds: 300_000_000)
        expenses.append(expense)
        localStore.saveExpenses(expenses)
        return expense
    }

    func deleteExpense(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        expenses.removeAll { $0.id == id }
        localStore.saveExpenses(expenses)
    }

    func filterExpenses(category: ExpenseCategory?, from: Date?, to: Date?) async throws -> [Expense] {
        try await Task.sleep(nanoseconds: 300_000_000)

        return expenses.filter { expense in
            let matchesCategory = category == nil || expense.category == category
            let matchesFrom = from == nil || expense.date >= from!
            let matchesTo = to == nil || expense.date <= to!

            return matchesCategory && matchesFrom && matchesTo
        }
        .sorted { $0.date > $1.date }
    }

    func fetchSummary() async throws -> [CategorySummary] {
        let totalAmount = expenses.reduce(0) { $0 + $1.amount }

        return ExpenseCategory.allCases.compactMap { category in
            let categoryExpenses = expenses.filter { $0.category == category }
            let categoryTotal = categoryExpenses.reduce(0) { $0 + $1.amount }

            guard categoryTotal > 0 else {
                return nil
            }

            return CategorySummary(
                category: category,
                total: categoryTotal,
                count: categoryExpenses.count,
                percentage: totalAmount == 0 ? 0 : (categoryTotal / totalAmount) * 100
            )
        }
    }
}
