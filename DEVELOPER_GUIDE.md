# Expense Tracker - Developer Guide

## Project Structure

```
lib/
├── main.dart                 # App entry point with navigation setup
├── models/
│   ├── expense_model.dart    # Data models (Expense, Category, Limit, Profile)
│   └── expense_provider.dart # State management with Provider
└── screens/
    ├── home_screen.dart      # Home page with pie chart
    ├── dashboard_screen.dart # User dashboard
    └── limit_setting_screen.dart # Budget limit settings
```

## File Details

### main.dart
- **MyApp**: Root widget with Material Design 3 theme
- **MainNavigationScreen**: Manages bottom navigation between 3 screens
- Navigation bar routes to Home, Dashboard, and Limits screens

### models/expense_model.dart

**ExpenseCategory** (Enum)
- 8 predefined categories with emoji and label
- food, transport, entertainment, shopping, utilities, health, education, other

**Expense** (Class)
- id: Unique identifier (UUID)
- title: Expense name
- amount: Spending amount
- category: ExpenseCategory
- date: Transaction date
- description: Optional notes

**ExpenseLimit** (Class)
- period: 'monthly' or 'yearly'
- limitAmount: Budget limit
- createdAt: When limit was set

**UserProfile** (Class)
- name: User's name
- email: User's email
- profileImage: Optional avatar URL
- joinDate: Account creation date

### models/expense_provider.dart

**ExpenseProvider** (ChangeNotifier)

#### Properties:
- `expenses`: List<Expense> - All recorded expenses
- `monthlyLimit`: ExpenseLimit? - Monthly budget
- `yearlyLimit`: ExpenseLimit? - Yearly budget
- `userProfile`: UserProfile - User information

#### Computed Properties:
- `totalExpenses`: Sum of all expenses
- `monthlyExpenses`: Current month's total
- `yearlyExpenses`: Current year's total
- `expensesByCategory`: Map of category → amount

#### Methods:
```dart
// Add/Remove expenses
void addExpense({...})
void removeExpense(String id)

// Budget management
void setMonthlyLimit(double amount)
void setYearlyLimit(double amount)

// Profile management
void updateUserProfile({...})

// Budget queries
bool isMonthlyLimitExceeded()
bool isYearlyLimitExceeded()
double getMonthlyLimitRemaining()
double getYearlyLimitRemaining()
```

### screens/home_screen.dart

**HomeScreen** (StatefulWidget)

Main components:
1. **_buildHeader**: Welcome message with user profile avatar
2. **_buildTotalExpenseCard**: Gradient card with spending summary
3. **_buildPieChart**: fl_chart pie chart with legend
4. **_buildExpenseList**: Recent 5 expenses with swipe actions
5. **_showAddExpenseDialog**: Modal bottom sheet for adding expenses

Features:
- Interactive pie chart from fl_chart
- Real-time category breakdown
- Quick expense addition
- Scrollable layout

### screens/dashboard_screen.dart

**DashboardScreen** (StatefulWidget)

Main components:
1. **_buildProfileCard**: Gradient card with user info
2. **_buildStatisticsGrid**: 2x2 grid of key metrics
3. **_buildBudgetStatus**: Progress indicators for budgets
4. **_buildTopCategories**: Ranked spending breakdown
5. **_buildRecentTransactions**: Last 5 expenses

Features:
- Comprehensive spending analysis
- Budget status visualization
- Category ranking
- Edit profile functionality

### screens/limit_setting_screen.dart

**LimitSettingScreen** (StatefulWidget)

Main components:
1. **_buildLimitCard**: Monthly/yearly limit configuration
2. **_buildRecommendationsSection**: Budget advice cards
3. **_buildAlertsSection**: Budget exceeded warnings
4. **_buildAlertCard**: Individual alert display

Features:
- Two separate limit inputs
- Real-time progress display
- Budget recommendations
- Smart alerts for exceeded limits

## State Management Flow

```
ExpenseProvider (ChangeNotifier)
├── Manages all app state
├── Notifies listeners on changes
└── Used by:
    ├── HomeScreen (pie chart data)
    ├── DashboardScreen (statistics)
    └── LimitSettingScreen (budget limits)
```

## Color Scheme

| Use | Color | Hex |
|-----|-------|-----|
| Primary | Blue | #2196F3 |
| Secondary | Purple | #9C27B0 |
| Success | Green | #4CAF50 |
| Warning | Amber | #FFC107 |
| Danger | Red | #F44336 |
| Background | Grey 50 | #FAFAFA |

## Dependencies

```yaml
fl_chart: ^0.64.0      # Pie chart visualization
intl: ^0.20.0          # Date formatting
provider: ^6.1.0       # State management
uuid: ^4.0.0           # Unique IDs
google_fonts: ^6.2.1   # Custom fonts (optional)
```

## Key Features Implementation

### 1. Pie Chart
- Located in `home_screen.dart`
- Uses `fl_chart` package
- Dynamically sized based on expense data
- Filtered to show only categories with expenses
- Color-coded with legend

### 2. Budget Limits
- Stored in `ExpenseProvider`
- Separate monthly and yearly limits
- Calculated automatically from expenses
- Progress indicators with percentage
- Alerts when exceeded

### 3. Data Aggregation
- All calculations in `ExpenseProvider`
- Category breakdown via `expensesByCategory`
- Monthly/yearly filtering via date comparison
- Remaining budget calculations

## Common Modifications

### Add New Expense Category
1. Edit `expense_model.dart`:
```dart
enum ExpenseCategory {
  newCategory('Label', 'emoji'),
  // ...
}
```

### Change Color Scheme
1. In `main.dart`, update:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.yourColor),
)
```

### Add New Screen
1. Create `lib/screens/new_screen.dart`
2. Import in `main.dart`
3. Add to `_screens` list in `_MainNavigationScreenState`
4. Add `NavigationDestination` to bottom navigation

### Change Sample Data
1. Edit `expense_provider.dart`
2. Modify the `_expenses` initialization in constructor

## Testing the App

### Test Scenarios:
1. **Add Expense**: Verify appears in list and pie chart
2. **Pie Chart**: Check categories update correctly
3. **Budget**: Set limit and verify progress indicators
4. **Dashboard**: Ensure stats match data
5. **Navigation**: Test all three tab switches
6. **Edit Profile**: Verify profile updates persist

### Sample Data Included:
- 4 pre-filled expenses with different categories
- Covers food, transport, entertainment, shopping
- Dates span multiple days

## Future Enhancement Ideas

### Phase 2:
- Persistent storage (SQLite/Hive)
- Edit/delete expense functionality
- Category-specific budgets
- Expense search and filtering

### Phase 3:
- Data export (CSV/PDF)
- Multiple accounts
- Recurring expenses
- Bill reminders
- Cloud backup

### Phase 4:
- Dark mode
- Custom categories
- Multi-currency support
- OCR receipt scanning
- AI spending insights

## Performance Considerations

- Pie chart regenerates only on expense changes (via Consumer)
- List building uses shrinkWrap for nested scrolls
- All calculations are O(n) where n = expense count
- No external API calls (all local data)

## Error Handling

Currently minimal error handling. Consider adding:
- Input validation for amounts
- Date picker for expense dates
- Loading states for async operations
- Error boundaries for UI crashes

## Code Quality

- Uses proper null safety
- Follows Flutter naming conventions
- Organized imports
- Separated concerns (models, screens, state)
- Responsive design patterns

---

Last Updated: February 2026
