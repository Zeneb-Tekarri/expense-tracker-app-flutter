# Expense Tracker App

A cross-platform expense tracking application built with Flutter that helps users manage their income and expenses, organize transactions, and gain insights into their spending habits.

## Features

### Transaction Management
- Add new income and expense transactions
- Edit existing transactions
- Delete transactions with a simple swipe
- Real-time balance updates

### Categories & Organization
- Categorize transactions
- Support for income and expense categories
- Transaction date selection

### Search & Filtering
- Search transactions by title or category
- Filter by transaction type
- Filter by category
- Filter by date range
- Combine multiple filters

### 💰 Budget Tracking
- Create budgets for expense categories
- Set spending limits
- Track spending against category budgets
- View spent and remaining amounts
- Visual budget progress indicators
- Identify exceeded budgets
- Budget progress updates based on transactions

### Data Storage
- Local SQLite database
- Persistent offline storage


## Tech Stack
- **Flutter**
- **Dart**
- **SQLite (sqflite)**
- **Provider** (State Management)
- **Intl** (Date Formatting)

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or VS Code
- Android Emulator or Physical Device

### Installation

Clone the repository:

```bash
git clone https://github.com/Zeneb-Tekarri/expense-tracker-app-flutter.git
cd expense-tracker-app-flutter
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 📌 Current Version

**v1.1.0 — Budget Tracking**

### What's included

- Transaction CRUD operations
- Income and expense tracking
- Transaction categories
- Transaction dates
- Search
- Advanced filtering
- SQLite local persistence
- Provider state management
- Category-based budget tracking
- Budget progress monitoring
- Remaining budget calculation
- Budget exceeded status

## 🗺️ Future Improvements

- Charts and spending analytics
- Export transaction data
- Notifications and budget alerts
- Dark mode
