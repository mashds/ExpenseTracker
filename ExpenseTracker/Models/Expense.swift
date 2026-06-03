//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation

enum ExpenseCategory: String, CaseIterable, Codable, Identifiable {
    case food
    case transport
    case entertainment
    case shopping
    case bills
    case other

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}

struct Expense: Identifiable, Codable, Equatable {
    let id: String
    let amount: Double
    let currency: String
    let category: ExpenseCategory
    let note: String?
    let date: Date
    let createdAt: Date
}
