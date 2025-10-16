# Transaction Module

This module handles transaction and category management using Isar local database.

## Structure

```
transaction/
├── models/
│   ├── category.dart          # Category model definition
│   ├── category.g.dart        # Generated Isar schema
│   ├── transaction.dart       # Transaction model definition
│   └── transaction.g.dart     # Generated Isar schema
└── repo/
    ├── category_repo.dart     # Category CRUD operations
    └── transaction_repo.dart  # Transaction CRUD operations
```

## Models

### Transaction

Fields:

- `id` (Id) - Auto-incremented ID
- `date` (DateTime) - Transaction date (set time to midnight for date-only)
- `type` (TransactionType) - Either `pengeluaran` (expense) or `pemasukan` (income)
- `description` (String?) - Optional description
- `category` (String?) - Optional category
- `amount` (int) - Transaction amount

### Category

Fields:

- `id` (Id) - Auto-incremented ID
- `name` (String) - Category name

## Usage Examples

### Creating a Transaction

```dart
final transactionRepo = Get.find<TransactionRepo>();

final transaction = Transaction()
  ..date = DateTime(2024, 1, 15) // Date at midnight
  ..type = TransactionType.pengeluaran
  ..description = 'Grocery shopping'
  ..category = 'Food'
  ..amount = 150000;

final result = await transactionRepo.createTransaction(transaction);

result.when(
  onSuccess: (transaction) {
    print('Transaction created with ID: ${transaction.id}');
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

### Getting All Transactions

```dart
final transactionRepo = Get.find<TransactionRepo>();

// Get all transactions (sorted by date descending by default)
final result = await transactionRepo.getAllTransactions();

result.when(
  onSuccess: (transactions) {
    print('Found ${transactions.length} transactions');
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

### Getting Transactions with Filters

```dart
final transactionRepo = Get.find<TransactionRepo>();

// Get all expenses
final result = await transactionRepo.getAllTransactions(
  type: TransactionType.pengeluaran,
);

// Get all income
final result2 = await transactionRepo.getAllTransactions(
  type: TransactionType.pemasukan,
);

// Get transactions by category
final result3 = await transactionRepo.getAllTransactions(
  category: 'Food',
);

// Get transactions in date range
final result4 = await transactionRepo.getAllTransactions(
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime(2024, 1, 31),
);

// Combine multiple filters
final result5 = await transactionRepo.getAllTransactions(
  type: TransactionType.pengeluaran,
  category: 'Food',
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime(2024, 1, 31),
  sortByDateDesc: true, // or false for ascending
);

result.when(
  onSuccess: (transactions) {
    print('Found ${transactions.length} transactions');
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

### Updating a Transaction

```dart
final transactionRepo = Get.find<TransactionRepo>();

// Get existing transaction
final getResult = await transactionRepo.getTransactionById(1);

if (getResult.hasData && getResult.data != null) {
  final transaction = getResult.data!;
  transaction.amount = 200000;
  transaction.description = 'Updated description';

  final updateResult = await transactionRepo.updateTransaction(transaction);

  updateResult.when(
    onSuccess: (updatedTransaction) {
      print('Transaction updated successfully');
    },
    onFailure: (error) {
      print('Error: $error');
    },
  );
}
```

### Deleting a Transaction

```dart
final transactionRepo = Get.find<TransactionRepo>();

final result = await transactionRepo.deleteTransaction(1);

result.when(
  onSuccess: (deleted) {
    if (deleted) {
      print('Transaction deleted successfully');
    } else {
      print('Transaction not found');
    }
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

### Getting Financial Summary

```dart
final transactionRepo = Get.find<TransactionRepo>();

// Get total income
final incomeResult = await transactionRepo.getTotalIncome();

// Get total expenses
final expensesResult = await transactionRepo.getTotalExpenses();

// Get balance
final balanceResult = await transactionRepo.getBalance();

if (balanceResult.hasData) {
  print('Current balance: ${balanceResult.data}');
}
```

### Creating a Category

```dart
final categoryRepo = Get.find<CategoryRepo>();

final category = Category()..name = 'Food';

final result = await categoryRepo.createCategory(category);

result.when(
  onSuccess: (category) {
    print('Category created with ID: ${category.id}');
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

### Getting All Categories

```dart
final categoryRepo = Get.find<CategoryRepo>();

final result = await categoryRepo.getAllCategories();

result.when(
  onSuccess: (categories) {
    print('Found ${categories.length} categories');
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

### Searching Categories

```dart
final categoryRepo = Get.find<CategoryRepo>();

final result = await categoryRepo.searchCategoriesByName('Food');

result.when(
  onSuccess: (categories) {
    print('Found ${categories.length} matching categories');
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

### Checking if Category Exists

```dart
final categoryRepo = Get.find<CategoryRepo>();

final result = await categoryRepo.categoryExists('Food');

result.when(
  onSuccess: (exists) {
    if (exists) {
      print('Category already exists');
    } else {
      print('Category does not exist');
    }
  },
  onFailure: (error) {
    print('Error: $error');
  },
);
```

## Using in Controllers

```dart
class TransactionListController extends BaseController {
  final TransactionRepo transactionRepo = Get.find<TransactionRepo>();

  List<Transaction> transactions = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions({
    TransactionType? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isLoading = true;
    update();

    final result = await transactionRepo.getAllTransactions(
      type: type,
      category: category,
      startDate: startDate,
      endDate: endDate,
      sortByDateDesc: true,
    );

    result.when(
      onSuccess: (data) {
        transactions = data;
        isLoading = false;
        update();
      },
      onFailure: (error) {
        isLoading = false;
        update();
        // Show error to user
        print('Error loading transactions: $error');
      },
    );
  }

  Future<void> deleteTransaction(Id id) async {
    final result = await transactionRepo.deleteTransaction(id);

    result.when(
      onSuccess: (deleted) {
        if (deleted) {
          loadTransactions(); // Reload list
        }
      },
      onFailure: (error) {
        print('Error deleting transaction: $error');
      },
    );
  }
}
```

## Important Notes

1. **Date Handling**: When storing dates without time, make sure to set the time to midnight:

   ```dart
   transaction.date = DateTime(2024, 1, 15); // This sets time to 00:00:00
   ```

2. **Dependency Injection**: Both repositories are registered in `init_di.dart` and can be accessed using `Get.find<TransactionRepo>()` or `Get.find<CategoryRepo>()`.

3. **Resource Pattern**: All repository methods return `Resource<T, String>` for consistent error handling. Use the `.when()` method to handle success and failure cases.

4. **Isar Initialization**: The `IsarService` automatically initializes Isar on first use. No manual initialization is required.

5. **Transaction Types**: Use the enum `TransactionType.pengeluaran` for expenses and `TransactionType.pemasukan` for income.
