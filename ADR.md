# Architecture Decision Records

This document records the key architecture decisions made for the Expense Tracker iOS application.

---

## ADR-001: Use MVVM Architecture

**Status:** Accepted

### Context

The Expense Tracker application requires a clear separation between the user interface, business logic, and data handling.

The app needs to support:

- Viewing expenses
- Adding expenses
- Deleting expenses
- Filtering expenses
- Showing loading, empty, and error states
- Unit testing business/domain logic

SwiftUI works well with observable state, so a ViewModel-based approach is suitable.

### Decision

Use the MVVM architecture pattern.

The project is separated into:

- **View**: SwiftUI screens such as `ExpenseListView`, `AddExpenseView`, `ExpenseRowView`, and `SummaryView`
- **ViewModel**: `ExpenseListViewModel`, which manages UI state and business logic
- **Model**: `Expense`, `ExpenseCategory`, and `CategorySummary`
- **Repository/Data Layer**: Handles communication with the mock API and local store

### Alternatives Considered

- **MVC**: Simpler, but can lead to large view controllers/views with mixed responsibilities.
- **Clean Architecture**: Strong separation, but heavier than needed for the assignment scope.
- **MVI**: Good for predictable state management, but adds extra complexity for this small module.

### Consequences

MVVM keeps the UI layer clean and makes business logic easier to test.

The main tradeoff is that the ViewModel can grow if too much logic is added later. If the app becomes larger, business logic can be moved into separate use case classes.

---

## ADR-002: Use Repository Pattern with Mock API

**Status:** Accepted

### Context

The assignment states that a real backend is not required. However, the data and network layers should be designed as if real endpoints exist.

The required mock endpoints are:

- `GET /api/expenses`
- `POST /api/expenses`
- `DELETE /api/expenses/{id}`
- `GET /api/expenses?category={cat}&from={date}&to={date}`
- `GET /api/expenses/summary`

The mock implementation should be replaceable with a real HTTP client with minimal changes.

### Decision

Use a protocol-based API and Repository pattern.

Main components:

- `ExpenseAPI`
- `MockExpenseAPI`
- `ExpenseRepositoryProtocol`
- `ExpenseRepository`

The ViewModel communicates with the repository instead of directly accessing the mock API.

### Alternatives Considered

- **Direct mock data inside ViewModel**: Faster to implement, but tightly couples UI state with data handling.
- **Direct URLSession calls from ViewModel**: Not suitable because there is no real backend and it reduces testability.
- **Repository with real API only**: Not needed for the assignment because backend integration is not required.

### Consequences

This approach improves separation of concerns and makes the app easier to test.

The mock API can later be replaced with a real networking implementation without changing the ViewModel significantly.

---

## ADR-003: Use UserDefaults for Simple Offline Persistence

**Status:** Accepted

### Context

Offline-first support with local persistence is listed as a stretch goal.

The app needs a simple way to persist expenses locally so that users can still see expenses after closing and reopening the app.

The app data is small and simple, so a lightweight persistence option is enough for this assignment.

### Decision

Use `UserDefaults` with JSON encoding and decoding for simple local persistence.

Expenses are encoded into JSON data and saved locally. When the app starts, saved expenses are loaded from local storage.

Main component:

- `ExpenseLocalStore`

### Alternatives Considered

- **Core Data**: More powerful and suitable for larger datasets, but more complex for this assignment.
- **SwiftData**: Modern and suitable for production use, but may require newer platform support and additional setup.
- **SQLite**: Flexible, but unnecessary for this small module.
- **In-memory only**: Simple, but does not support offline persistence after app restart.

### Consequences

UserDefaults is simple and fast to implement for small datasets.

The tradeoff is that UserDefaults is not ideal for large or complex data. For a production app, SwiftData or Core Data would be preferred.

---

## ADR-004: Use Client-Side Input Validation

**Status:** Accepted

### Context

Users need meaningful feedback when adding a new expense.

Invalid input such as empty amount, non-numeric amount, zero amount, very large amount, or future dates should not be saved.

### Decision

Perform client-side validation inside the ViewModel before saving the expense.

Validation rules include:

- Amount is required
- Amount must be a valid number
- Amount must be greater than zero
- Amount must not be too large
- Expense date cannot be in the future

If validation fails, the app shows a user-facing error message.

### Alternatives Considered

- **No validation**: Faster to implement, but creates poor user experience and invalid data.
- **Server-side validation only**: Not applicable because this assignment uses a mocked backend.
- **Validation only in the View**: Possible, but would mix UI with business logic and reduce testability.

### Consequences

Client-side validation improves user experience and prevents invalid data from entering the app state or local persistence.

In a real production system, server-side validation would still be required.

---

## ADR-005: Use SwiftUI List for Expense Rendering

**Status:** Accepted

### Context

The app needs to show a list of expenses sorted by date.

The list should support standard iOS behavior such as scrolling and swipe-to-delete.

### Decision

Use SwiftUI `List` to render expenses.

Each expense is displayed using a reusable `ExpenseRowView`.

### Alternatives Considered

- **ScrollView with VStack**: Simple, but less efficient for larger lists and does not provide built-in list behavior.
- **UIKit UITableView**: Efficient, but adds unnecessary complexity in a SwiftUI app.

### Consequences

SwiftUI `List` provides efficient row rendering and native iOS list behavior.

For very large datasets, pagination and more advanced data loading strategies may be needed.

---

## ADR-006: Use Currency Formatting Utility

**Status:** Accepted

### Context

The app displays expense amounts to the user.

Amounts should be shown in a readable currency format instead of plain decimal values.

### Decision

Create a reusable currency formatting helper.

Main component:

- `CurrencyFormatterHelper`

The formatter uses `NumberFormatter` to display amounts with currency formatting.

### Alternatives Considered

- **String interpolation only**: Simple, but less user-friendly.
- **Hardcoded formatting in each View**: Repetitive and harder to maintain.

### Consequences

Currency formatting is centralized and reusable.

The current implementation uses a fixed currency, `LKR`. In the future, this can be extended to support multi-currency selection.

---

## ADR-007: Add Accessibility Labels for Important UI Elements

**Status:** Accepted

### Context

The app should be usable with screen readers and accessibility features.

Expense rows, action buttons, and summary rows should provide meaningful descriptions.

### Decision

Add accessibility labels to important UI elements.

Examples:

- Expense rows combine category, amount, note, and date
- Add button is labelled as adding a new expense
- Filter button is labelled as filtering expenses
- Summary rows describe category total and percentage

### Alternatives Considered

- **Rely only on default SwiftUI accessibility**: Works partially, but may not provide enough context.
- **Add accessibility later**: Could miss the stretch goal and reduce app quality.

### Consequences

The app provides better support for VoiceOver and screen readers.

This improves usability and demonstrates attention to accessibility.

---

## ADR-008: Add Basic GitHub Actions CI

**Status:** Accepted

### Context

The assignment lists basic CI configuration as a stretch goal.

The project should be able to build and test automatically when code is pushed to GitHub.

### Decision

Add a GitHub Actions workflow file:

`.github/workflows/ios-ci.yml`

The workflow performs:

- Checkout
- Build
- Test

### Alternatives Considered

- **Manual testing only**: Simpler, but less reliable.
- **Fastlane**: Useful for advanced iOS automation, but more setup than needed here.
- **Bitrise/CircleCI**: Good options, but GitHub Actions is simpler for a GitHub repository.

### Consequences

CI helps confirm that the project builds and tests pass after changes.

The workflow may need small updates depending on the available Xcode version and simulator name in GitHub Actions.

