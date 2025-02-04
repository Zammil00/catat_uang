// models/database.dart
// ignore: duplicate_ignore
// ignore: unused_import
// ignore_for_file: unused_import

import 'package:catat_uang/models/transaction_with_category.dart';
import 'package:catat_uang/pages/transaction_page.dart';
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:drift/native.dart';
import 'category.dart';
import 'transaction.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Categories, Transactions],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

// CRUD CATEGORY
  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)..where((tbl) => tbl.type.equals(type)))
        .get();
  }

  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(name: Value(name)));
  }

  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  //Query TRANSACTION WITH CATEGORY
  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(
      DateTime date) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id))
    ])
      ..where(transactions.transaction_date.equals(date));

    return query.watch().map((rows) => rows
        .map((row) => TransactionWithCategory(
            row.readTable(transactions), row.readTable(categories)))
        .toList());
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
