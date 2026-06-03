# Expense Tracker iOS App

## Overview

Expense Tracker is a personal finance iOS application module that allows users to record daily expenses, categorize them, delete records, filter expenses, and view spending summaries.

The app uses mocked/stubbed API responses, but the data and network layers are designed so that the mock API can be replaced with a real HTTP client with minimal changes.

GitHub Repo Link - https://github.com/mashds/ExpenseTracker

## Features

- View recorded expenses sorted by date
- Add a new expense with amount, category, note, and date
- Delete an expense
- Filter expenses by category and date range
- View spending summary by category
- Empty, loading, and error states
- Input validation with meaningful user feedback
- Currency formatting
- Basic offline/local persistence using UserDefaults
- Accessibility labels for screen reader support

## Architecture

This project follows MVVM with Repository Pattern.

## Architecture Diagram

```mermaid
flowchart TD

    A[SwiftUI Views] --> B[ExpenseListViewModel]

    B --> C[ExpenseRepositoryProtocol]
    C --> D[ExpenseRepository]

    D --> E[ExpenseAPI Protocol]
    E --> F[MockExpenseAPI]

    F --> G[ExpenseLocalStore]
    G --> H[UserDefaults]

    B --> I[Expense Model]
    B --> J[CategorySummary Model]

    subgraph View Layer
        A
    end

    subgraph ViewModel Layer
        B
    end

    subgraph Repository Layer
        C
        D
    end

    subgraph Data Layer
        E
        F
        G
        H
    end

    subgraph Model Layer
        I
        J
    end

### Architecture Flow

The app follows MVVM with Repository Pattern.

SwiftUI View
↓
ViewModel
↓
Repository Protocol
↓
Repository Implementation
↓
API Protocol
↓
Mock API / Local Store
↓
UserDefaults

### View Layer

The View layer is built using SwiftUI.

Main views:

- ExpenseListView
- AddExpenseView
- ExpenseRowView
- SummaryView

The views are responsible only for displaying UI and collecting user input.

### ViewModel Layer

The ViewModel handles UI state and business logic.

Example responsibilities:

- Loading expenses
- Adding expenses
- Deleting expenses
- Applying filters
- Showing loading state
- Showing error messages
- Validating user input

Main ViewModel:

ExpenseListViewModel

### Repository Layer

The Repository layer separates the ViewModel from the data source.

Main files:

- ExpenseRepositoryProtocol.swift
- ExpenseRepository.swift

This makes the app easier to test and allows the mock API to be replaced with a real backend later.

### API Layer

The API layer follows a protocol-based design.

Main files:

- ExpenseAPI.swift
- MockExpenseAPI.swift

The mock API supports:

- GET /api/expenses
- POST /api/expenses
- DELETE /api/expenses/{id}
- GET /api/expenses?category={cat}&from={date}&to={date}
- GET /api/expenses/summary

## Data Models

### Expense

Fields:

- id: String
- amount: Double
- currency: String
- category: food, transport, entertainment, shopping, bills, other
- note: Optional String
- date: Date
- createdAt: Date

### Category Summary

Fields:

- category: ExpenseCategory
- total: Double
- count: Int
- percentage: Double

## Offline Support

The app includes basic offline/local persistence using UserDefaults.

Expenses are encoded as JSON and saved locally. This allows expenses to remain available even after the app is closed and reopened.

For a production app, SwiftData or Core Data would be better options for long-term storage and larger datasets.

## Input Validation

The app validates expense input before saving.

Validation rules:

- Amount is required
- Amount must be a valid number
- Amount must be greater than zero
- Amount must not be too large
- Expense date cannot be in the future

If validation fails, the user sees a clear error message.

## Spending Summary

The Summary screen displays a category-wise breakdown of expenses.

Each category summary includes:

- Category name
- Total amount
- Number of expenses
- Percentage of total spending
- Progress indicator

## Accessibility

Accessibility support has been added for important UI elements.

Examples:

- Expense rows use combined accessibility labels
- Add button has an accessibility label
- Filter button has an accessibility label
- Summary rows provide readable category, amount, and percentage information

This improves compatibility with VoiceOver and screen readers.

## Performance Considerations

- The expense list uses SwiftUI List, which provides efficient row rendering.
- Category summaries are calculated only when needed.
- Filtering is handled in the repository/data layer instead of directly in the UI.
- The mock API is abstracted behind a protocol, so it can be replaced with a real paginated API later.
- Local persistence uses JSON encoding for simplicity.
- For larger datasets, SwiftData/Core Data and pagination would be better choices.

## Project Structure

ExpenseTracker
│
├── App
│   └── ExpenseTrackerApp.swift
│
├── Models
│   ├── Expense.swift
│   └── CategorySummary.swift
│
├── Network
│   ├── ExpenseAPI.swift
│   └── MockExpenseAPI.swift
│
├── Persistence
│   └── ExpenseLocalStore.swift
│
├── Repository
│   ├── ExpenseRepositoryProtocol.swift
│   └── ExpenseRepository.swift
│
├── ViewModels
│   └── ExpenseListViewModel.swift
│
├── Views
│   ├── ExpenseListView.swift
│   ├── AddExpenseView.swift
│   ├── ExpenseRowView.swift
│   └── SummaryView.swift
│
├── Utils
│   ├── DateFormatterHelper.swift
│   └── CurrencyFormatterHelper.swift
│
├── ADR.md
└── README.md

## How to Build and Run

GitHub Repo Link - https://github.com/mashds/ExpenseTracker

1. Clone the repository.

git clone <repository-url>

2. Open the project in Xcode.

open ExpenseTracker.xcodeproj

3. Select an iPhone simulator.

Example:

iPhone 17

4. Press Command + R.

The app should build and run in the simulator.

## How to Run Tests

Open the project in Xcode and press:

Command + U

Or run from Terminal:

xcodebuild test -scheme ExpenseTracker -destination 'platform=iOS Simulator,name=iPhone 15'

## Unit Tests

The project includes unit tests for business/domain logic.

Covered areas:

- Adding an expense with valid data
- Fetching expenses sorted by date
- Calculating category summaries

Minimum requirement satisfied:

At least 3 meaningful unit tests covering business/domain logic.

## CI Configuration

Basic GitHub Actions CI is included in:

.github/workflows/ios-ci.yml

The workflow runs on push and pull request.

It performs:

- Checkout
- Build
- Test

## Assumptions

- Backend API is mocked.
- Currency is fixed as LKR.
- Expense categories are fixed.
- Authentication is not required for this module.
- Basic local persistence is implemented using UserDefaults.
- The app is designed for iOS 16 or later.

## What I Would Improve With More Time

- Replace UserDefaults with SwiftData or Core Data
- Add charts using Swift Charts
- Add multi-currency selection
- Add edit expense functionality
- Add search functionality
- Add better dependency injection
- Add pagination support for large expense lists
- Add more unit tests and UI tests
- Add production-ready networking using URLSession

## Architecture Decision Records

Architecture decisions are documented in:

ADR.md

Included ADR topics:

- MVVM architecture choice
- Repository pattern with mock API
- Local persistence strategy
- Client-side validation strategy

## AI Usage Evidence

AI tools (ChatGPT) were used to support the development of this Expense Tracker iOS application.

## Areas where AI was used

- Architecture planning
- SwiftUI implementation guidance
- MVVM and Repository Pattern setup
- Mock API design
- Local persistence guidance
- Unit test examples
- README and ADR documentation
- GitHub Actions CI troubleshooting
- Swift/Xcode error troubleshooting

## Sample Prompts Used

1. I need to build an iOS Expense Tracker module using SwiftUI. The app should allow users to view expenses, add expenses, delete expenses, filter by category/date, and view category summaries. Please suggest a clean architecture and folder structure.

2. Create Swift data models for an Expense Tracker app. The Expense model should include id, amount, currency, category, note, date, and createdAt.

3. Create a protocol-based mock API layer for an iOS SwiftUI Expense Tracker app.

4. Create a repository layer for the Expense Tracker app using the Repository Pattern.

5. Create a SwiftUI ViewModel for the Expense Tracker app using MVVM.

6. Create a SwiftUI expense list screen with loading, empty, error, add, filter, summary, and delete support.

7. Add input validation with meaningful user feedback.

8. Add offline persistence using UserDefaults.

9. Create XCTest unit tests for adding expenses, sorting expenses, and calculating summaries.

10. Create README.md and ADR.md documentation for the project.

## Review Statement

AI tools were used to assist with project planning, architecture guidance, SwiftUI implementation examples, troubleshooting, and documentation drafting.

All generated code and documentation were reviewed, adjusted, and tested before submission.

## Submission Checklist

Before submitting, verify:

- Code compiles and runs
- Expense list screen displays mocked/local expenses
- Add expense functionality works
- Delete expense functionality works
- Filter functionality works
- Spending summary screen works
- Loading state is handled
- Empty state is handled
- Error state is handled
- Input validation is implemented
- Accessibility labels are added
- README.md is present
- ADR.md is present with at least 2 decision records
- Unit tests pass
- CI workflow file is included
- No secrets, API keys, or credentials are committed
- Commit history shows incremental progress
