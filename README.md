# Expense Tracker — Flutter App

A modern, aesthetic expense tracker app built with Flutter

---

## Features

### Dashboard

- **Balance Card** showing Income, Total Expenses, and Remaining Balance
- **Smart Warning System** — card changes color based on spending:
  - 🟢 Safe (< 70% used) — Purple neon gradient
  - 🟡 Warning (70%+ used) — Yellow glow
  - 🟠 Alert (90%+ used) — Orange glow  
  - 🔴 Danger (100%+) — Red with pulsing glow
- Progress bar showing % of income used
- Quick list of current month's expenses

### Statistics

- Month selector to browse history
- **Interactive Pie Chart** (tap segments to see percentages)
- Category breakdown with progress bars
- "Highest Spending" category badge
- Comparison with previous month

### History

- All expenses grouped by month (collapsible)
- **Search** by name or category
- Swipe to delete
- Tap to edit

### Expense Management

- Add expenses with title, amount, category, date, and note
- Auto date (today by default), or pick any past date
- 9 default categories with emoji icons
- Create **custom categories**
- Edit & delete any expense

### UI

- **Dark / Light Mode** toggle (button in top right)
- Smooth animations with `flutter_animate`
- Bottom navigation: Home · Statistics · History
- No clunky Material defaults — custom-styled everything

---

## Setup

### Requirements

- Flutter 3.10+ SDK
- Dart 3.0+

### Steps

```bash
# 1. Navigate to project folder
cd expense_tracker

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

> **Note**: The Hive adapter files (`expense_model.g.dart`) are already pre-generated, so you **don't need to run `build_runner`**.  
> If you modify the models, run:  
> `flutter pub run build_runner build --delete-conflicting-outputs`

---

## Dependencies

| Package                 | Purpose                         |
| ----------------------- | ------------------------------- |
| `provider`              | State management                |
| `hive` + `hive_flutter` | Local database                  |
| `fl_chart`              | Pie chart for statistics        |
| `flutter_animate`       | Smooth animations               |
| `google_fonts`          | DM Sans typography              |
| `intl`                  | Date & currency formatting      |
| `uuid`                  | Unique IDs for expenses         |
| `vibration`             | Haptic feedback on danger level |

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
│   ├── dashboard_screen.dart    # Home screen
│   ├── statistics_screen.dart   # Charts & stats
│   └── history_screen.dart      # Expense history
└── widgets/
    ├── balance_card.dart        # Smart balance card
    ├── expense_list_item.dart   # Swipeable expense row
    ├── add_expense_sheet.dart   # Add/Edit bottom sheet
    └── set_income_sheet.dart    # Monthly income input
```

---

## How to Use

1. **Set your monthly income** — tap "Set Income" button at top right
2. **Add expenses** — tap the purple FAB button
3. **View statistics** — tap the 📊 tab
4. **Browse history** — tap the 📋 tab
5. **Toggle theme** — tap the 🌙/☀️ icon in the top right
6. **Delete expense** — swipe left on any expense
7. **Edit expense** — tap on any expense

---

## Color Palette

```dart
Dark Background:  #17181F
Dark Card:        #1E1F2A  
Neon Purple:      #6C72CB
Neon Pink:        #CB69C1
Light Text:       #EEEDF0
```
