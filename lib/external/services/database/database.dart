import 'package:nequo/external/services/database/migrations/v2.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const QuotesTable = 'Quotes';
const FavoritesTable = 'Favorites';

Future<Database> initDb() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'nequo_database.db'),
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON;');
    },
    onUpgrade: onUpgrade,
    onCreate: onCreate,
    version: 2,
  );

  return database;
}
