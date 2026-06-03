//
//  SummaryView.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import SwiftUI

struct SummaryView: View {

    @ObservedObject var viewModel: ExpenseListViewModel

    var body: some View {
        List {
            if viewModel.summaries.isEmpty {
                ContentUnavailableView(
                    "No Summary Available",
                    systemImage: "chart.pie",
                    description: Text("Add expenses to see category breakdown.")
                )
            } else {
                ForEach(viewModel.summaries) { summary in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(summary.category.displayName)
                                .font(.headline)

                            Spacer()

                            Text(CurrencyFormatterHelper.format(amount: summary.total))
                                .font(.headline)
                        }

                        ProgressView(value: summary.percentage, total: 100)

                        Text("\(summary.count) expenses • \(summary.percentage, specifier: "%.1f")% of total spending")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(summary.category.displayName), total \(CurrencyFormatterHelper.format(amount: summary.total)), \(summary.percentage, specifier: "%.1f") percent")
                }
            }
        }
        .navigationTitle("Summary")
        .task {
            await viewModel.loadSummary()
        }
    }
}
