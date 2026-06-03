//
//  ExpenseListView.swift
//  ExpenseTracker
//
//  Created by Maheesha De Silva on 2026-06-03.
//

import SwiftUI

struct ExpenseListView: View {

    @StateObject private var viewModel: ExpenseListViewModel

    @State private var showAddExpense = false
    @State private var showFilter = false

    init() {
        let api = MockExpenseAPI()
        let repository = ExpenseRepository(api: api)
        _viewModel = StateObject(
            wrappedValue: ExpenseListViewModel(repository: repository)
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading expenses...")
                } else if viewModel.expenses.isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "tray",
                        description: Text("Tap + to add your first expense.")
                    )
                } else {
                    List {
                        ForEach(viewModel.expenses) { expense in
                            ExpenseRowView(expense: expense)
                        }
                        .onDelete(perform: viewModel.deleteExpense)
                    }
                    .refreshable {
                        await viewModel.loadExpenses()
                    }
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink("Summary") {
                        SummaryView(viewModel: viewModel)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
            .sheet(isPresented: $showFilter) {
                filterSheet
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "Something went wrong.")
            }
            .task {
                await viewModel.loadExpenses()
            }
        }
    }

    private var filterSheet: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        Text("All").tag(nil as ExpenseCategory?)

                        ForEach(ExpenseCategory.allCases) { category in
                            Text(category.displayName).tag(category as ExpenseCategory?)
                        }
                    }
                }

                Section("Date Range") {
                    DatePicker(
                        "From",
                        selection: Binding(
                            get: { viewModel.fromDate ?? Date() },
                            set: { viewModel.fromDate = $0 }
                        ),
                        displayedComponents: .date
                    )

                    DatePicker(
                        "To",
                        selection: Binding(
                            get: { viewModel.toDate ?? Date() },
                            set: { viewModel.toDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                }

                Button("Clear Filters") {
                    viewModel.selectedCategory = nil
                    viewModel.fromDate = nil
                    viewModel.toDate = nil

                    Task {
                        await viewModel.loadExpenses()
                    }

                    showFilter = false
                }
            }
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        showFilter = false
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        Task {
                            await viewModel.applyFilter()
                            showFilter = false
                        }
                    }
                }
            }
        }
    }
}
