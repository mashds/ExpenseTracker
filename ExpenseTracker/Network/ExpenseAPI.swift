//
//  ExpenseAPI.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation

protocol ExpenseAPI {
    func fetchExpenses() async throws -> [Expense]
    func addExpense(_ expense: Expense) async throws -> Expense
    func deleteExpense(id: String) async throws
    func filterExpenses(category: ExpenseCategory?, from: Date?, to: Date?) async throws -> [Expense]
    func fetchSummary() async throws -> [CategorySummary]
}
