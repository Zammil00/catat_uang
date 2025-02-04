import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  // ignore: non_constant_identifier_names
  IntColumn get category_id => integer()();
  // ignore: non_constant_identifier_names
  DateTimeColumn get transaction_date => dateTime()();
  IntColumn get amount => integer()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
