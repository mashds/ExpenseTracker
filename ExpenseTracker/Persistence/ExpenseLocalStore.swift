//
//  ExpenseLocalStore.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation

protocol ExpenseLocalStoreProtocol {
    func saveExpenses(_ expenses: [Expense])
    func loadExpenses() -> [Expense]
}

final class ExpenseLocalStore: ExpenseLocalStoreProtocol {

    private let key = "saved_expenses"

    func saveExpenses(_ expenses: [Expense]) {
        do {
            let data = try JSONEncoder().encode(expenses)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save expenses: \(error)")
        }
    }

    func loadExpenses() -> [Expense] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Expense].self, from: data)
        } catch {
            print("Failed to load expenses: \(error)")
            return []
        }
    }
}
