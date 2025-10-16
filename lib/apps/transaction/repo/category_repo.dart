import 'package:isar/isar.dart';

import '../../../base/resource.dart';
import '../../../utilities/isar_service.dart';
import '../models/category.dart';

class CategoryRepo {
  /// Get Isar instance
  Future<Isar> get _isar => IsarService.getInstance();

  /// Create a new category
  Future<Resource<Category, String>> createCategory(Category category) async {
    try {
      final isar = await _isar;
      await isar.writeTxn(() async {
        await isar.categorys.put(category);
      });
      return category.toResourceSuccess();
    } catch (e) {
      return 'Failed to create category: $e'.toResourceFailure();
    }
  }

  /// Get a category by ID
  Future<Resource<Category?, String>> getCategoryById(Id id) async {
    try {
      final isar = await _isar;
      final category = await isar.categorys.get(id);
      return category.toResourceSuccess();
    } catch (e) {
      return 'Failed to get category: $e'.toResourceFailure();
    }
  }

  /// Get all categories
  Future<Resource<List<Category>, String>> getAllCategories() async {
    try {
      final isar = await _isar;
      final categories = await isar.categorys.where().findAll();
      return categories.toResourceSuccess();
    } catch (e) {
      return 'Failed to get categories: $e'.toResourceFailure();
    }
  }

  /// Get categories sorted by name
  Future<Resource<List<Category>, String>> getCategoriesSortedByName() async {
    try {
      final isar = await _isar;
      final categories = await isar.categorys.where().sortByName().findAll();
      return categories.toResourceSuccess();
    } catch (e) {
      return 'Failed to get sorted categories: $e'.toResourceFailure();
    }
  }

  /// Search categories by name
  Future<Resource<List<Category>, String>> searchCategoriesByName(
      String query) async {
    try {
      final isar = await _isar;
      final categories = await isar.categorys
          .filter()
          .nameContains(query, caseSensitive: false)
          .findAll();
      return categories.toResourceSuccess();
    } catch (e) {
      return 'Failed to search categories: $e'.toResourceFailure();
    }
  }

  /// Check if category name already exists
  Future<Resource<bool, String>> categoryExists(String name) async {
    try {
      final isar = await _isar;
      final count = await isar.categorys
          .filter()
          .nameEqualTo(name, caseSensitive: false)
          .count();
      return (count > 0).toResourceSuccess();
    } catch (e) {
      return 'Failed to check category existence: $e'.toResourceFailure();
    }
  }

  /// Update a category
  Future<Resource<Category, String>> updateCategory(Category category) async {
    try {
      final isar = await _isar;
      await isar.writeTxn(() async {
        await isar.categorys.put(category);
      });
      return category.toResourceSuccess();
    } catch (e) {
      return 'Failed to update category: $e'.toResourceFailure();
    }
  }

  /// Delete a category by ID
  Future<Resource<bool, String>> deleteCategory(Id id) async {
    try {
      final isar = await _isar;
      bool deleted = false;
      await isar.writeTxn(() async {
        deleted = await isar.categorys.delete(id);
      });
      return deleted.toResourceSuccess();
    } catch (e) {
      return 'Failed to delete category: $e'.toResourceFailure();
    }
  }

  /// Delete multiple categories by IDs
  Future<Resource<int, String>> deleteCategories(List<Id> ids) async {
    try {
      final isar = await _isar;
      int count = 0;
      await isar.writeTxn(() async {
        count = await isar.categorys.deleteAll(ids);
      });
      return count.toResourceSuccess();
    } catch (e) {
      return 'Failed to delete categories: $e'.toResourceFailure();
    }
  }

  /// Delete all categories
  Future<Resource<bool, String>> deleteAllCategories() async {
    try {
      final isar = await _isar;
      await isar.writeTxn(() async {
        await isar.categorys.clear();
      });
      return true.toResourceSuccess();
    } catch (e) {
      return 'Failed to delete all categories: $e'.toResourceFailure();
    }
  }
}
