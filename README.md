# Expense Tracker — Flutter App

A modern, aesthetic personal finance companion app built with Flutter. Designed to help users understand their daily money habits through smart tracking, visual insights, and an intelligent warning system — all stored fully offline.

---

## Preview

## Features

## Home Dashboard

- **Smart Balance Card** showing remaining balance, income, and total expenses
- **Month-switching** — tap the month title to browse any past month's data without leaving the dashboard
- **Context-aware Set Income** — always sets income for the month currently being viewed
- **"Browsing past month" banner** with one-tap return to current month
- **Recent expenses list** filtered to the selected month

### Smart Warning System

The balance card dynamically changes color based on spending level — no configuration needed:

| Spending Level | Card Color           |
| -------------- | -------------------- |
| Under 70%      | Purple neon gradient |
| 70% – 89%      | Yellow glow          |
| 90% – 99%      | Orange glow          |
| 100%+          | Red pulse            |

### Budget Goal Feature

- Set a monthly spending limit directly from the balance card
- A dedicated progress bar tracks spending against the goal — separate from income
- Turns red and shows "Over by $X" when the goal is exceeded
- Tap the goal row to edit or remove it at any time
- Goals are stored per month so each month has its own limit

### Transaction Management

- Add expenses with title, amount, category, date, and optional note
- Auto-date defaults to today (or last day of the viewed month when browsing past)
- **Edit** any expense by tapping it
- **Delete** with swipe-left — confirm dialog prevents accidents
- **9 default categories** with emoji icons: Food & Drink, Transport, Entertainment, Shopping, Bills, Health, Education, Travel, Others
- **Custom categories** — create your own, long-press to delete them

## Statistics Screen

- Interactive pie chart with income shown as a remaining grey slice
- Tap any slice to see the amount and percentage in the centre label
- Month selector with gradient pills (no color clash with categories)
- Category breakdown list with progress bars showing % of income
- Income summary row inside the chart card

## History Screen

- All expenses grouped by month in collapsible cards
- Month header cards are visually distinct (gradient background) from expense rows
- **Search** by expense name, category, or month name (e.g. "March", "January 2026")
- Swipe to delete with confirm dialog
- Tap any expense to edit

### UI & Experience

- **Dark / Light mode** toggle — persists across sessions
- **Syne font** (loaded fully offline from assets — no internet required)
- **Dark neon palette**: `#17181F` · `#6C72CB` · `#CB69C1` · `#EEEDF0`
- **Swipeable screens** via PageView — swipe between Home, Statistics, History
- **Splash screen** with animated neon logo, app title, subtitle, and author credit
- Smooth animated transitions throughout
- Empty states for all screens
- Confirm dialogs on all destructive actions

---

## Architecture & Technical Decisions

### State Management — Provider

`provider` is used for all app-wide state including:

- Expense and income data
- Dark/light mode toggle
- Dashboard month selection (stored in provider so it survives screen navigation)
- Custom categories
The `ExpenseProvider` class is the single source of truth, separating all business logic from the UI layer.

### Local Database — Hive

`hive` is used as the local NoSQL database for:

- **Expense objects** — stored in a typed `Box<Expense>`
- **Monthly income** — stored in a typed `Box<MonthlyIncome>`

Hive was chosen for its speed, zero-config setup, and Flutter-native integration. Type adapters are pre-generated (`expense_model.g.dart`).

### Lightweight Storage — SharedPreferences

`shared_preferences` is used for simple key-value data:

- Custom categories list
- Monthly budget goals (keyed as `goal_2026-04`)
- App theme preference

---

## Setup

### Requirements

- Flutter 3.10+ SDK
- Dart 3.0+

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/sabihaniaz7/Expense-Tracker-Flutter.git
cd Expense-Tracker-Flutter

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

[!IMPORTANT]
**Note**: The Hive adapter files (`expense_model.g.dart`) are already pre-generated, so you **don't need to run `build_runner`**.  
If you modify the models, run:  
`flutter pub run build_runner build --delete-conflicting-outputs`

---

## Dependencies

| Package              | Version    | Purpose                            |
| -------------------- | ---------- | ---------------------------------- |
| `provider`           | `^6.1.5+1` | State management                   |
| `hive`               | `^2.2.3`   | Local database                     |
| `hive_flutter`       | `^1.1.0`   | Hive Flutter integration           |
| `fl_chart`           | `^1.2.0`   | Interactive charts                 |
| `intl`               | `^0.20.2`  | Date & currency formatting         |
| `uuid`               | `^4.5.3`   | Unique IDs for database objects    |
| `shared_preferences` | `^2.5.5`   | Local settings                     |
| `cupertino_icons`    | `^1.0.8`   | iOS icons library                  |

---

## Project Structure

```text
lib/
├── main.dart                    # App entry + navigation
├── models/
│   ├── expense_model.dart       # Hive data models
│   └── expense_model.g.dart     # Generated adapter
├── providers/
│   └── expense_provider.dart    # State + business logic
├── theme/
│   └── app_theme.dart           # Colors, typography, categories
├── screens/
│   ├── splash_screen.dart       # Animated splash with author credit
│   ├── dashboard_screen.dart    # Home screen
│   ├── statistics_screen.dart   # Charts & stats
│   └── history_screen.dart      # Expense history
└── widgets/
    ├── balance_card.dart        # Smart balance card
    ├── expense_list_item.dart   # Swipeable expense row
    ├── add_expense_sheet.dart   # Add/Edit bottom sheet
    ├── set_income_sheet.dart    # Monthly income input
    └── set_goal_sheet.dart      # Monthly budget goal input sheet
```

---

## Design Decisions & Assumptions

**Month-switching dashboard** — Rather than a separate "history balance" screen, the dashboard itself becomes context-aware. Tapping the month title switches the entire view — balance card, expense list, Set Income, and budget goal all update to reflect the selected month. This keeps the app to 3 screens while solving the "how do I see last month's balance?" problem elegantly.

**Budget goal vs income** — Income is what you earn. Budget goal is what you *choose* to spend. These are deliberately separate so users can set a goal below their income as a savings discipline tool.

**Warning system** — The colour-shifting balance card was designed as a passive, always-visible alert system. No notifications needed — just glance at the card colour. This feels more natural for a daily-use finance app.

**Offline-first** — No backend, no sign-in, no permissions required. All data lives on the device. The app works instantly from first launch with zero setup friction.

**Font bundled locally** — Syne is loaded from `assets/fonts/` so the app never makes a network request for typography. Works fully offline from the first frame.

---
