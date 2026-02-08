# Expense Tracker

A modern Flutter application designed to help you track and manage your personal expenses with an attractive UI and comprehensive features.

## Features

### 🔐 Authentication
- **Login Screen**: Secure sign-in with email and password
- **Register Screen**: Create new account with name, email, and password
- **Form Validation**: Real-time validation for all input fields
- **Password Visibility Toggle**: Option to show/hide password
- **Terms of Service**: Agreement checkbox before registration
- **Auto-redirect**: Automatic navigation to main app after authentication

### 🏠 Home Screen
- **Pie Chart Visualization**: Visual representation of your spending across different expense categories
- **Total Expense Summary**: Quick overview of total, monthly, and yearly expenses
- **Recent Expenses List**: Shows your 5 most recent transactions with category emoji, date, and amount
- **Quick Add Expense**: Floating action button to quickly add new expenses

### 📊 Dashboard
- **User Profile Card**: Display user information with profile avatar and membership date
- **Statistics Overview**: Grid showing total expenses, monthly, yearly, and total transactions
- **Budget Status**: Visual progress indicators showing spending against budget limits
- **Top Spending Categories**: Breakdown of your top spending categories with percentages
- **Recent Transactions**: Quick view of recent expense transactions
- **Edit Profile**: Update your name and email information

### ⚙️ Expense Limits
- **Monthly Budget Limit**: Set and monitor your monthly spending limit
- **Yearly Budget Limit**: Set and monitor your yearly spending limit
- **Budget Alerts**: Get alerted when you exceed your set limits
- **Budget Recommendations**: Follow the 50/30/20 budgeting rule or set conservative limits
- **Visual Progress Indicators**: See your spending progress with color-coded indicators

## Expense Categories

- 🍔 Food
- 🚗 Transport
- 🎬 Entertainment
- 🛍️ Shopping
- ⚡ Utilities
- 🏥 Health
- 📚 Education
- 📌 Other

## Key Components

### Data Models
- **Expense**: Represents a single expense transaction
- **ExpenseCategory**: Enum for expense categories
- **ExpenseLimit**: Represents monthly/yearly budget limits
- **UserProfile**: User information and metadata

### State Management
- **AuthProvider**: Handles authentication state
  - Login/logout functionality
  - User registration
  - Authentication state tracking
  - Error handling
- **ExpenseProvider**: Central provider using Provider package for state management
  - Manage expenses list
  - Calculate totals and breakdowns
  - Handle budget limits
  - Track user profile

### Screens
1. **LoginScreen**: User authentication with email/password
2. **RegisterScreen**: New user registration with form validation
3. **HomeScreen**: Main dashboard with pie chart and expense history
4. **DashboardScreen**: Detailed user dashboard with statistics
5. **LimitSettingScreen**: Configure budget limits and view alerts

## Getting Started

### Prerequisites
- Flutter SDK (3.10.8 or higher)
- Dart SDK

### Installation

1. Navigate to the project directory:
```bash
cd flutter_application_1
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Dependencies

```yaml
- flutter: SDK
- cupertino_icons: ^1.0.8
- fl_chart: ^0.64.0
- intl: ^0.20.0
- provider: ^6.1.0
- google_fonts: ^6.2.1
- uuid: ^4.0.0
```

## Usage

### Authentication
1. **Login**: Enter your email and password on the login screen, then tap "Sign In"
2. **Register**: Tap "Sign Up" to create a new account
   - Enter your full name, email, and password
   - Confirm your password
   - Agree to Terms of Service
   - Tap "Create Account"
3. **Logout**: Access from the Profile screen (coming soon)

> **Note**: For demo purposes, any valid email/password combination will work for login.

### Adding an Expense
1. Tap the floating action button (+) on the home screen
2. Enter the expense details:
   - Title (required)
   - Amount (required)
   - Category (dropdown selection)
   - Description (optional)
3. Tap "Add Expense" to save

### Setting Budget Limits
1. Navigate to the "Limits" tab
2. Enter your desired monthly or yearly limit amount
3. View your current spending progress
4. Tap "Save Limit" to confirm

### Viewing Statistics
1. Navigate to the "Dashboard" tab
2. View comprehensive statistics including:
   - Total spending across all time
   - Monthly and yearly totals
   - Budget usage percentages
   - Top spending categories
   - Recent transactions

## Application Theme

The app features a modern Material Design 3 theme with:
- Blue color scheme as the primary color
- Gradient cards for important information
- Color-coded alerts for budget status
- Responsive design that works on all screen sizes
- Smooth transitions and animations

## Data Persistence Notes

Currently, the app stores data in memory. For production use, consider implementing:
- SQLite or Firebase for persistent storage
- Local data backup and sync
- Cloud synchronization for multi-device access

## Future Enhancements

- 💾 Persistent data storage (SQLite/Firebase)
- 📈 Advanced analytics and reports
- 🏷️ Budget categories customization
- 🔔 Smart expense notifications
- 📱 Multiple currency support
- 🌙 Dark mode theme
- 📤 Export expenses to CSV/PDF
- � Biometric authentication
- 📧 Email verification
- 🔑 Password reset functionality
- 🔗 Social login (Google, Apple)

## License

This project is open source and available for personal use.

## Support

For issues or feature requests, please create an issue in the project repository.

---

**Version**: 1.0.0  
**Last Updated**: February 2026

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
