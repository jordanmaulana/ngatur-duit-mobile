import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  /// Auto-incremented ID for the category
  Id id = Isar.autoIncrement;

  /// Name of the category
  late String name;
}
