# Ngatur Duit - Personal Finance Mobile App

A comprehensive Flutter mobile application for personal financial management with offline-first architecture, multi-wallet support, and transaction tracking. This project demonstrates best practices in Flutter development including offline database management, pragmatic layering architecture, and online-offline synchronization patterns.

![Preview](.gif/demo.gif)

## 🎯 Learning Objectives

This project is designed as a practical learning resource for:

1. **Offline Database in Flutter**

   - Using Isar Community as local database
   - Model design with relationship management
   - Efficient queries and filtering
   - Data persistence strategies

2. **Pragmatic Layering Architecture**

   - Clean separation of concerns (Model → Repository → Controller → View)
   - Service layer for business logic
   - Dependency injection with GetX
   - Reusable components and utilities

3. **Online Database Synchronization**
   - Handling offline and online states
   - Data sync patterns
   - Conflict resolution strategies
   - Resource pattern for API responses

## 📱 Features

### Implemented

- ✅ Transaction Management (Income & Expenses)
- ✅ Multi-Wallet Support
- ✅ Category Management
- ✅ Dashboard with Summary Statistics
- ✅ Transaction History & Filtering
- ✅ Offline-First Data Persistence
- ✅ Thousand Separator Currency Formatting
- ✅ Responsive UI with Modern Design

### Coming Soon

- 🚀 User Profile Management
- 🚀 Online Synchronization
- 🚀 Budget Planning
- 🚀 Financial Analytics
- 🚀 Multi-Account Support

## 🛠 Tech Stack

### Framework & Language

- **Flutter**: 3.32.6 (Stable)
- **Dart**: 3.8.1
- **Platform**: Android, iOS, Web

### State Management

- **GetX**: Reactive state management and routing
- **GetBuilder**: Simple, efficient state updates

### Database & Storage

- **Isar Community**: High-performance local database
- **Path Provider**: Platform-aware file paths

### UI & Styling

- **HugeIcons**: Consistent icon library
- **Google Fonts**: Typography
- **Material Design 3**: Modern UI components

### Utilities

- **intl**: Date/currency internationalization
- **package_info_plus**: App version management
- **url_launcher**: Deep linking support

## 📂 Project Structure

```
lib/
├── apps/                           # Feature modules
│   ├── auth/                       # Authentication (future)
│   ├── dashboard/                  # Dashboard feature
│   │   ├── controllers/            # State management
│   │   ├── views/                  # UI screens
│   │   └── widgets/                # Reusable components
│   ├── transaction/                # Transaction feature
│   │   ├── models/                 # Data models
│   │   ├── repo/                   # Repository layer
│   │   ├── controllers/            # Business logic
│   │   └── views/                  # UI screens
│   ├── wallet/                     # Wallet feature
│   │   ├── models/                 # Wallet data model
│   │   ├── repositories/           # Wallet repository
│   │   ├── controllers/            # Wallet controllers
│   │   └── views/                  # Wallet UI
│   ├── profile/                    # User profile (coming soon)
│   └── main_nav/                   # Navigation management
├── base/                           # Base classes & exports
│   ├── base_controller.dart        # Controller base class
│   ├── export_view.dart            # Common imports
│   └── resource.dart               # Response wrapper
├── configs/                        # Configuration
│   ├── colors.dart                 # App color palette
│   ├── constants.dart              # App constants
│   └── flavors.dart                # Build flavors
├── extensions/                     # Dart extensions
│   ├── my_string_extension.dart    # String utilities
│   ├── size_extension.dart         # Size calculations
│   └── number_format_extension.dart # Currency formatting
├── ui/                            # Shared UI components
│   ├── components/                # Reusable widgets
│   └── screens/                   # Full-screen layouts
├── utilities/                     # Application utilities
│   ├── isar_service.dart          # Database service
│   ├── number_formatter.dart      # Number formatting utility
│   └── logger.dart                # Logging utility
├── init_di.dart                   # Dependency injection setup
├── main.dart                      # App entry point
├── main_production.dart           # Production flavor
└── main_staging.dart              # Staging flavor
```

## 🏗 Architecture Overview

### Pragmatic Layering

The project follows a pragmatic approach to layering without being overly rigid:

```
┌─────────────────────────────────────┐
│           View Layer (UI)            │ ← Pages, Widgets, Dialogs
├─────────────────────────────────────┤
│      Controller Layer (Logic)        │ ← GetX Controllers, State Management
├─────────────────────────────────────┤
│      Repository Layer (Data)         │ ← Data access, API/DB operations
├─────────────────────────────────────┤
│      Model Layer (Entities)          │ ← Data structures, Isar models
└─────────────────────────────────────┘
```

### Key Components

**Model** (`lib/apps/*/models/`)

- Defines data structures
- Isar collection annotations for persistence
- Serialization/deserialization

**Repository** (`lib/apps/*/repo/` or `*/repositories/`)

- Encapsulates data access logic
- Handles both local (Isar) and remote (API) operations
- Returns `Resource<T, E>` for consistent error handling
- Example: `TransactionRepository`, `WalletRepository`

**Controller** (`lib/apps/*/controllers/`)

- Extends `BaseDetailController`
- Manages UI state with GetX
- Orchestrates business logic
- Reactive updates with `update()`

**View** (`lib/apps/*/views/`)

- Presents UI to user
- Uses `GetBuilder<ControllerType>` for reactivity
- Imports through `export_view.dart` for consistency

### Resource Pattern

```dart
Resource<Data, Error> result = await repository.getData();

result.when(
  onSuccess: (data) => print(data),
  onFailure: (error) => print(error),
);
```

## 🗄 Database Schema

### Isar Collections

**Transaction**

- Core entity for expense/income tracking
- Fields: id, type, amount, category, description, date, walletId
- Relationships: Linked to Wallet via walletId

**Wallet**

- Storage container for money
- Fields: id, name, balance, createdAt, updatedAt
- Auto-creates "Dompet Utama" (Main Wallet) on app launch

**Category**

- Expense/Income categorization
- Fields: id, name, type, createdAt, updatedAt
- Pre-populated with common categories

## 💾 Data Persistence Strategy

### Local Database (Isar)

- **Fast**: Pure Dart implementation, no native bridge
- **Efficient**: ACID transactions
- **Flexible**: Supports relationships and queries
- Initialization in `IsarService` singleton

### Offline-First Approach

```dart
// 1. Write to local database immediately
await isar.writeTxn(() async {
  await isar.transactions.put(transaction);
});

// 2. Sync to server (when online)
// 3. Handle conflicts if needed
```

### Auto-Sync Pattern

```dart
// Transactions reference walletId
// All operations scoped to specific wallet
// Enables future server synchronization
```

## 🎨 UI/UX Patterns

### Design System

- **Color Palette**: Teal primary (#00786F), with accent gradients
- **Typography**: Google Fonts (Inter, Inter Tight)
- **Icons**: HugeIcons (strokeRounded style)
- **Spacing**: 8px, 12px, 16px, 24px increments

### Component Library

- `VText`: Styled text component
- `VFormInput`: Form field with validation
- `VButton`: Primary/Secondary buttons
- `VLoading`: Loading states
- `VToast`: Toast notifications
- `VPopup`: Modal dialogs
- `StandardAppbar`: Consistent app bar with gradient

### Responsive Design

- Adaptive layouts using `MediaQuery`
- ScrollView for content overflow
- Safe area padding for notches
- Device-aware spacing

## 🔧 Utilities & Extensions

### Number Formatting

```dart
// Currency formatting with thousand separator
int amount = 50000;
print(amount.formatCurrency); // "50,000"

// Parse formatted currency
String formatted = "50,000";
double parsed = formatted.parseFormattedCurrency; // 50000.0

// Input formatter
inputFormatters: [ThousandSeparatorInputFormatter()]
```

### String Extensions

```dart
// Capitalize first letter
'hello'.capitalize; // 'Hello'

// Safe null handling
optionalString?.orEmpty; // '' if null
```

### Size Extensions

```dart
// Responsive sizing
context.screenWidth;
context.screenHeight;
context.isPhone;
```

## 🚀 Getting Started

### Prerequisites

- Flutter 3.32.6 or higher
- Dart 3.8.1 or higher
- Android SDK 21+ or iOS 12.0+

### Installation

```bash
# Clone the repository
git clone https://github.com/jordanmaulana/ngatur-duit-mobile.git
cd ngatur-duit-mobile

# Get dependencies
flutter pub get

# Generate code (Isar models, etc.)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Or with specific flavor
flutter run --flavor staging -t lib/main_staging.dart
```

### Initial Setup

The app auto-initializes on first launch:

1. Creates Isar database schema
2. Creates "Dompet Utama" (Main Wallet) if none exists
3. Loads pre-configured categories
4. Sets up dependency injection

## 🏃 Running

### Development

```bash
flutter run
```

### Staging Build

```bash
flutter run --flavor staging -t lib/main_staging.dart
```

### Production Build

```bash
flutter run --flavor production -t lib/main_production.dart
```

### Build Release APK

```bash
flutter build apk --release
```

## 📊 Key Learning Points

### Offline Database

1. **Model Design**: See `Transaction` and `Wallet` models
2. **CRUD Operations**: Check `TransactionRepository`
3. **Querying**: Filter transactions by date, wallet, type
4. **Relationships**: Transactions reference wallets
5. **Performance**: Isar's indexing for fast queries

### Architecture

1. **Separation of Concerns**: Clear layer boundaries
2. **Dependency Injection**: GetX `Get.put()`, `Get.lazyPut()`
3. **State Management**: Simple `GetBuilder` for controllers
4. **Error Handling**: `Resource<T, E>` pattern
5. **Code Reusability**: Extensions, utilities, components

### Online Sync (Foundation)

1. **Resource Wrapper**: API response consistency
2. **Wallet ID References**: Enable server linking
3. **Timestamps**: Track creation/update for sync
4. **Field Planning**: `onlineId`, `synchronized` for future sync

## 📚 Learning Resources in Code

### Database

- `lib/utilities/isar_service.dart` - Database initialization
- `lib/apps/wallet/models/wallet.dart` - Model with relationships
- `lib/apps/transaction/repo/transaction_repo.dart` - Repository pattern

### Architecture

- `lib/init_di.dart` - Dependency injection setup
- `lib/base/base_controller.dart` - Controller base class
- `lib/apps/transaction/controllers/transaction_form_controller.dart` - Complex controller

### UI Patterns

- `lib/apps/dashboard/views/dashboard_page.dart` - Multi-component page
- `lib/ui/components/` - Reusable component library
- `lib/extensions/number_format_extension.dart` - Extension usage

## 🧪 Testing Strategy

**Unit Tests**: Added for complex business logic

- Number formatting utilities
- Data validation
- Calculation logic

**Widget Tests**: For critical UI components

- Form validation
- List rendering
- State updates

**Integration Tests**: For complete user flows

- Transaction creation flow
- Data persistence
- Navigation

## 🔒 Best Practices Implemented

✅ **Consistent Error Handling**: `Resource` pattern for all operations
✅ **Type Safety**: Strong typing throughout
✅ **Code Organization**: Clear feature-based structure
✅ **Reusable Components**: DRY principle applied
✅ **Dependency Injection**: All services managed by GetX
✅ **Internationalization**: Indonesian language support (i18n ready)
✅ **Performance**: Efficient queries, lazy loading
✅ **Documentation**: Well-commented code

## 🤝 Contributing

This is a learning project. Contributions for improvements are welcome:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📝 License

This project is open source and available under the MIT License.

## 👨‍💻 Author

**Jordan Maulana** - Initial development and architecture

---

## 📖 Additional Resources

- [Isar Documentation](https://isar.dev/)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Flutter Docs](https://flutter.dev/docs)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture)

---

**Happy Learning! 🚀**

Made with ❤️ for Flutter developers learning architecture and offline-first development patterns.
