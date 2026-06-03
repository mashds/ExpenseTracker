//
//  CategorySummary.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import Foundation

struct CategorySummary: Identifiable, Equatable {
    let id = UUID()
    let category: ExpenseCategory
    let total: Double
    let count: Int
    let percentage: Double
}
