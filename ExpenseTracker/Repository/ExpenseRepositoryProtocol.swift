//
//  ExpenseRepositoryProtocol.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation

protocol ExpenseRepositoryProtocol {
    func getExpenses() async throws -> [Expense]
    func addExpense(amount: Double, currency: String, category: ExpenseCategory, note: String?, date: Date) async throws -> Expense
    func deleteExpense(id: String) async throws
    func filterExpenses(category: ExpenseCategory?, from: Date?, to: Date?) async throws -> [Expense]
    func getSummary() async throws -> [CategorySummary]
}
