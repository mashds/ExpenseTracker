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
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(summary.category.displayName)
                                .font(.headline)

                            Spacer()

                            Text("LKR \(summary.total, specifier: "%.2f")")
                                .font(.headline)
                        }

                        Text("\(summary.count) expenses • \(summary.percentage, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Summary")
        .task {
            await viewModel.loadSummary()
        }
    }
}
