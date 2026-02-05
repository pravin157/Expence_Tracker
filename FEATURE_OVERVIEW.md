# Expense Tracker - Feature Overview

## 🏠 HOME SCREEN

```
┌─────────────────────────────────────┐
│  Welcome back!  [👤 Avatar]         │  Header with greeting
│  John Doe                           │
├─────────────────────────────────────┤
│                                     │
│  Total Expenses         [📈]        │  Blue Gradient Card
│  $77.80                            │
│  Monthly: $77.80 / No limit         │
│  Yearly: $77.80 / No limit          │
│                                     │
├─────────────────────────────────────┤
│  Expense Distribution               │  Section Title
│                    [Pie Chart]      │  Interactive visualization
│  🍔 Food          $25.50  32.8%    │  with legend below
│  🚗 Transport     $12.00  15.4%    │
│  🎬 Entertainment $15.00  19.3%    │
│  🛍️ Shopping      $65.30  84.0%    │
│                                     │
├─────────────────────────────────────┤
│  Recent Expenses         [View All] │  Recent transactions
│                                     │
│  🍔 Lunch at Restaurant  Jan 3      │
│  -$25.50 | Food                     │
│                                     │
│  🚗 Taxi fare           Jan 2       │
│  -$12.00 | Transport                │
│                                     │
│  🎬 Movie ticket        Jan 1       │
│  -$15.00 | Entertainment            │
│                                     │
│  🛍️ Grocery shopping    Dec 31      │
│  -$65.30 | Shopping                 │
│                                     │
│  🍔 Coffee             Dec 30       │
│  -$5.00 | Food                      │
│                                     │
├─────────────────────────────────────┤
│              [➕ Add Expense]        │  Floating Action Button
└─────────────────────────────────────┘
```

### Features:
- ✓ Interactive pie chart with categories
- ✓ Real-time expense tracking
- ✓ Category-wise breakdown
- ✓ Recent 5 transactions
- ✓ Quick-add expense button
- ✓ Budget limit preview

---

## 📊 DASHBOARD SCREEN

```
┌─────────────────────────────────────┐
│  Dashboard              [✏️]         │  Edit Profile
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │  User Profile Card
│  │ [J] John Doe                  │  │  (Gradient Purple)
│  │     john@example.com          │  │
│  │     Member since Jan 2026      │  │
│  └───────────────────────────────┘  │
│                                     │
├─────────────────────────────────────┤
│  Statistics Overview                │
│                                     │
│  ┌──────────────────┐ ┌───────────┐│
│  │ 💰 Total        │ │📅 Monthly  ││
│  │ $77.80          │ │$77.80      ││
│  └──────────────────┘ └───────────┘│
│                                     │
│  ┌──────────────────┐ ┌───────────┐│
│  │ 📆 This Year    │ │📋 Trans.  ││
│  │ $77.80          │ │4          ││
│  └──────────────────┘ └───────────┘│
│                                     │
├─────────────────────────────────────┤
│  Budget Status                      │
│                                     │
│  Monthly Budget                     │
│  ████████░░░░░░░░░░ 67%            │  Progress bar
│  $67 / $100        Remaining: $33   │
│                                     │
│  Yearly Budget                      │
│  ████░░░░░░░░░░░░░░ 32%            │  Progress bar
│  $32 / $100        Remaining: $68   │
│                                     │
├─────────────────────────────────────┤
│  Top Spending Categories            │
│                                     │
│  🛍️ Shopping                        │
│  $65.30 ████████░░░░░░░░░░         │  84%
│                                     │
│  🍔 Food                            │
│  $25.50 ███░░░░░░░░░░░░░░░░░░░     │  32%
│                                     │
│  🎬 Entertainment                   │
│  $15.00 ██░░░░░░░░░░░░░░░░░░░░░   │  19%
│                                     │
│  🚗 Transport                       │
│  $12.00 █░░░░░░░░░░░░░░░░░░░░░░░  │  15%
│                                     │
├─────────────────────────────────────┤
│  Recent Transactions                │
│                                     │
│  🛍️ Grocery shopping     Dec 31     │
│  -$65.30                            │
│                                     │
│  🎬 Movie ticket        Jan 1       │
│  -$15.00                            │
│                                     │
│  🚗 Taxi fare           Jan 2       │
│  -$12.00                            │
│                                     │
└─────────────────────────────────────┘
```

### Features:
- ✓ User profile with avatar
- ✓ Key statistics grid
- ✓ Budget progress tracking
- ✓ Top spending categories
- ✓ Transaction history
- ✓ Edit profile option

---

## ⚙️ LIMITS SETTING SCREEN

```
┌─────────────────────────────────────┐
│  Set Expense Limits                 │
├─────────────────────────────────────┤
│                                     │
│  📅 Monthly Limit                   │
│                                     │
│  Set a budget limit for monthly...  │
│                                     │
│  Amount: [           ] $            │  Input field
│                                     │
│  Spent: $77.80 / $100.00  147% 🔴  │  Status
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░           │  Progress bar
│  Over limit by $47.80               │  Alert
│                                     │
│  [Cancel]  [Save Limit]             │  Buttons
│                                     │
├─────────────────────────────────────┤
│                                     │
│  📆 Yearly Limit                    │
│                                     │
│  Set a budget limit for yearly...   │
│                                     │
│  Amount: [           ] $            │  Input field
│                                     │
│  Spent: $77.80 / $500.00  15% 🟢    │  Status
│  ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │  Progress bar
│  Remaining: $422.20                 │  Safe
│                                     │
│  [Cancel]  [Save Limit]             │  Buttons
│                                     │
├─────────────────────────────────────┤
│  Budget Recommendations             │  Tips section
│                                     │
│  🥧 50/30/20 Rule                  │
│  50% needs, 30% wants, 20% savings  │
│                                     │
│  📉 Set Conservative Limits         │
│  Start low and adjust as needed      │
│                                     │
│  📊 Review Monthly                  │
│  Check regularly and adjust limits   │
│                                     │
├─────────────────────────────────────┤
│  Budget Alerts          ⚠️ WARNING   │  When limit exceeded
│                                     │
│  Monthly Limit Exceeded              │
│  You have exceeded your monthly...   │
│  by $47.80                           │
│                                     │
│  Yearly Limit Exceeded               │
│  You have exceeded your yearly...    │
│  by $22.15                           │
│                                     │
└─────────────────────────────────────┘
```

### Features:
- ✓ Monthly budget input
- ✓ Yearly budget input
- ✓ Real-time progress tracking
- ✓ Visual indicators (green/red)
- ✓ Remaining budget display
- ✓ Budget recommendations
- ✓ Alert system for exceeded limits

---

## 🧭 NAVIGATION

```
┌────────────────────────────────────────────────┐
│                 HOME SCREEN                    │
│         (Pie Chart & Recent Expenses)          │
├────────────────────────────────────────────────┤
│                                                │
│      [🏠]        [📊]        [⚙️]              │
│      Home        Dashboard   Limits            │
│     (Active)     (Inactive)  (Inactive)        │
│                                                │
└────────────────────────────────────────────────┘

TAP DASHBOARD →

┌────────────────────────────────────────────────┐
│                DASHBOARD SCREEN                │
│         (Statistics & Budget Status)           │
├────────────────────────────────────────────────┤
│                                                │
│      [🏠]        [📊]        [⚙️]              │
│      Home       Dashboard   Limits             │
│    (Inactive)   (Active)   (Inactive)          │
│                                                │
└────────────────────────────────────────────────┘

TAP LIMITS →

┌────────────────────────────────────────────────┐
│              LIMITS SETTING SCREEN             │
│         (Budget Management & Alerts)           │
├────────────────────────────────────────────────┤
│                                                │
│      [🏠]        [📊]        [⚙️]              │
│      Home       Dashboard    Limits            │
│    (Inactive)   (Inactive)   (Active)          │
│                                                │
└────────────────────────────────────────────────┘
```

---

## 🎯 EXPENSE CATEGORIES

| Emoji | Category | Use Cases |
|-------|----------|-----------|
| 🍔 | Food | Groceries, restaurants, meals, snacks |
| 🚗 | Transport | Gas, parking, public transit, taxi |
| 🎬 | Entertainment | Movies, games, hobbies, concerts |
| 🛍️ | Shopping | Clothes, accessories, general items |
| ⚡ | Utilities | Electricity, water, internet, phone |
| 🏥 | Health | Medical, gym, wellness, dentist |
| 📚 | Education | Books, courses, tuition, learning |
| 📌 | Other | Anything that doesn't fit above |

---

## ➕ ADD EXPENSE DIALOG

```
┌─────────────────────────────────────┐
│  Add New Expense                    │
├─────────────────────────────────────┤
│                                     │
│  Title                              │
│  [Lunch at Restaurant         ]    │  Input
│                                     │
│  Amount                             │
│  [$ 25.50                     ]    │  Input
│                                     │
│  Category                           │
│  [🍔 Food                    ▼]    │  Dropdown
│                                     │
│  Description (optional)             │
│  [Good meal with friends      ]    │  Multi-line
│  [                            ]    │  Input
│                                     │
│  [Cancel]        [Add Expense]      │  Buttons
│                                     │
└─────────────────────────────────────┘
```

---

## 📊 DATA FLOW

```
User Input
    ↓
[Add Expense Modal]
    ↓
ExpenseProvider.addExpense()
    ↓
[Add to List, Calculate Totals]
    ↓
notifyListeners()
    ↓
[Rebuild Widgets]
    ├─→ HomeScreen [Update Pie Chart]
    ├─→ DashboardScreen [Update Stats]
    └─→ LimitSettingScreen [Update Progress]
```

---

## 🎨 COLOR SCHEME

```
Primary Colors:
  🔵 Blue #2196F3      (Main theme)
  🟣 Purple #9C27B0    (Secondary)

Status Colors:
  🟢 Green #4CAF50     (Good/Safe)
  🟠 Amber #FFC107     (Caution)
  🔴 Red #F44336       (Alert/Danger)

Neutral:
  ⚪ White #FFFFFF     (Background)
  ⚫ Grey #9E9E9E      (Text secondary)
```

---

## 📱 RESPONSIVE DESIGN

The app is designed to work perfectly on:
- 📱 Mobile phones (320px - 600px width)
- 📱 Tablets (600px - 1200px width)
- 💻 Larger screens (1200px+)

All widgets:
- Adapt to screen size
- Scale proportionally
- Maintain readability
- Use flexible layouts

---

**This visual overview shows the complete user interface and feature set of your Expense Tracker application. All screens are fully functional and integrated!** ✨
