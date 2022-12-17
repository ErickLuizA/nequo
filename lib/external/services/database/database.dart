import 'package:flutter/foundation.dart';
import 'package:nequo/external/services/database/migrations/v2.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const QuotesTable = 'Quotes';
const AuthorsTable = 'Authors';
const TagsTable = 'Tags';
const FavoritesTable = 'Favorites';

Future<Database> initDb() async {
  if (kDebugMode) {
    await databaseFactory.debugSetLogLevel(sqfliteLogLevelSql);
  }

  final database = await openDatabase(
    join(await getDatabasesPath(), 'nequo_database.db'),
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON;');
    },
    onUpgrade: onUpgrade,
    onCreate: onCreate,
    version: 3,
  );

  return database;
}
