//
//  ExpenseTrackerTests.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import XCTest
@testable import ExpenseTracker

@MainActor
final class ExpenseTrackerTests: XCTestCase {

    func testAddExpenseWithValidAmount() async throws {
        let api = MockExpenseAPI()
        let repository = ExpenseRepository(api: api)

        let expense = try await repository.addExpense(
            amount: 1000,
            currency: "LKR",
            category: .food,
            note: "Dinner",
            date: Date()
        )

        let amount = expense.amount
        let currency = expense.currency
        let category = expense.category

        XCTAssertEqual(amount, 1000)
        XCTAssertEqual(currency, "LKR")
        XCTAssertEqual(category, .food)
    }

    func testFetchExpensesReturnsSortedExpenses() async throws {
        let api = MockExpenseAPI()
        let repository = ExpenseRepository(api: api)

        let expenses = try await repository.getExpenses()

        XCTAssertFalse(expenses.isEmpty)

        for index in 0..<expenses.count - 1 {
            let currentDate = expenses[index].date
            let nextDate = expenses[index + 1].date

            XCTAssertGreaterThanOrEqual(currentDate, nextDate)
        }
    }

    func testSummaryCalculationReturnsCategoryTotals() async throws {
        let api = MockExpenseAPI()
        let repository = ExpenseRepository(api: api)

        let summaries = try await repository.getSummary()

        XCTAssertFalse(summaries.isEmpty)

        let allTotalsAreGreaterThanZero = summaries.allSatisfy { summary in
            summary.total > 0
        }

        let allCountsAreGreaterThanZero = summaries.allSatisfy { summary in
            summary.count > 0
        }

        XCTAssertTrue(allTotalsAreGreaterThanZero)
        XCTAssertTrue(allCountsAreGreaterThanZero)
    }
}
