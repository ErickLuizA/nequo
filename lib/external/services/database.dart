import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initDb() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'nequo_database.db'),
    onCreate: (db, version) async {
      await db.execute("""
        CREATE TABLE Favorites(
          id INTEGER PRIMARY KEY, 
          content TEXT,
          author TEXT
          )
        """);

      await db.execute("""
        CREATE TABLE QuoteList(
          id INTEGER PRIMARY KEY, 
          name TEXT
          )
        """);

      await db.execute("""
        CREATE TABLE Quotes(
          id INTEGER PRIMARY KEY, 
          listId INTEGER,
          content TEXT,
          author TEXT,
          
          FOREIGN KEY(listId) REFERENCES QuoteList(id)
          )
        """);

      await db.execute("""
        CREATE TRIGGER DeleteQuotes
        AFTER DELETE ON QuoteList
        FOR EACH ROW
        BEGIN
            DELETE FROM Quotes WHERE listId = OLD.id;
        END
      """);
    },
    version: 1,
  );

  return database;
}
