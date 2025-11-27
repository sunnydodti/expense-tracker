---
applyTo: '**'
---
You are an expert Flutter developer. When generating code or reviewing changes for this project, strictly adhere to the following performance guidelines and best practices, tailored to the `expense_tracker` codebase:

## 1. Widget Optimization & Rendering
- **Remove `shrinkWrap: true` in Lists**: In `ExpenseList` (`lib/ui/widgets/expense/expense_list.dart`) and similar widgets, `ListView.builder` is used with `shrinkWrap: true` inside `Expanded`. This negates lazy loading benefits. Always use `shrinkWrap: false` (default) when the list is inside a bounded parent (like `Expanded` or `SizedBox`).
- **Avoid Side Effects in `build`**: Do not trigger state changes (e.g., `provider.refreshExpenses()`) inside `FutureBuilder` within a `build` method (as seen in `ExpenseList` and `MyApp`). This causes unnecessary rebuilds. Use `initState` or `didChangeDependencies` for initial data fetching.
- **Optimize `DataTable`**: `ExpenseItemsScreen` uses `DataTable`. For large datasets, this is performance-heavy. Prefer a custom `ListView` or a paginated data table if the item count grows.
- **Use `const` Constructors**: Ensure all stateless widgets and static children (icons, text styles) use `const`.
- **Minimize `Opacity`**: Use `AnimatedOpacity` or `FadeTransition` instead of `Opacity` for animations.
- **Use Defined Constants**: Reuse values defined in `lib/data/constants/` (e.g., `ui_constants.dart` for padding/sizes, `theme_constants.dart` for themes) instead of hardcoding magic numbers or colors. This ensures consistency and easier maintenance.

## 2. State Management (Provider)
- **Optimize `ExpenseProvider`**:
  - The getters `getTotalBalance`, `getTotalIncome`, and `getTotalExpenses` iterate over the entire `_expenses` list. Cache these values and update them only when the list changes, rather than recalculating on every access or rebuild.
  - Use `Selector<ExpenseProvider, T>` instead of `Consumer<ExpenseProvider>` when a widget only needs a specific part of the state (e.g., just the total balance) to prevent rebuilding the entire widget tree when the list changes.
- **Granular Rebuilds**: In `ExpenseItemsScreen`, `Consumer<ExpenseItemsProvider>` wraps the whole list. Ensure individual list items are optimized (e.g., `const` widgets where possible) so that updating one item doesn't force a layout pass of the entire list structure.

## 3. Asynchronous Operations & Initialization
- **Proper Initialization**: `ExpenseProvider` initializes services asynchronously in `_init` without awaiting in the constructor. Ensure critical services are initialized before the app starts (in `main.dart` or a splash screen) to avoid race conditions.
- **Avoid Blocking Main Thread**: Offload heavy data processing (e.g., parsing large JSONs or processing large export files in `ExportService`) to Isolates using `compute()`.
- **Pagination**: `refreshExpenses` in `ExpenseProvider` fetches *all* expenses. As the database grows, this will become a bottleneck. Implement pagination or limit/offset in `ExpenseService` and `ExpenseProvider` for the main list.

## 4. Database (Sqflite)
- **Batch Operations**: When deleting or adding multiple items (e.g., `deleteExpenseItem`), use `batch` operations in `SqfliteService` to reduce transaction overhead.
- **Indexes**: Ensure columns used for filtering and sorting (e.g., `date`, `category`, `amount`) are indexed in the SQLite database.

## 5. Memory & Resource Management
- **Dispose Controllers**: Verify that all `TextEditingController`s in forms (e.g., `ExpenseForm`, `ExpenseItemForm`) are properly disposed.
- **Image Caching**: If adding image attachments to expenses, use `cached_network_image` or efficient local caching.

## 6. Code Structure & Responsive Layout
- **Responsive Widgets**: The app uses `MobileScaffold`, `TabletScaffold`, etc. Ensure that shared widgets (like `ExpenseList`) adapt their layout constraints efficiently without unnecessary wrapping (e.g., avoid nested `Expanded`s that fight for space).
- **Separation of Concerns**: Keep business logic in `Providers` and `Services`. UI widgets should only handle display and user interaction events.

## 7. Specific Anti-Patterns to Fix
- **`FutureBuilder` in `build`**: Refactor `ExpenseList` to fetch data in `initState` or via a route argument, removing the `FutureBuilder` that calls `refreshExpensesHome`.
- **Recursive/Looping Calculations**: Avoid calling heavy calculation methods (like `getTotalBalance`) inside loops or frequently rebuilt widgets.

Note - keep your responses succinct and to ponint.