import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const CategoriesTable = 'Categories';
const QuotesTable = 'Quotes';
const FavoritesTable = 'Favorites';

Future<Database> initDb() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'nequo_database.db'),
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON;');
    },
    onCreate: (db, version) async {
      await db.execute("""
        create table $CategoriesTable(
          id integer primary key, 
          server_id integer null,
          name varchar(50) unique,
        
          created_at timestamp default current_timestamp,
          updated_at timestamp default current_timestamp
        );
      """);

      await db.execute("""
        create trigger categories_on_update
            after update on Categories
            begin
              update Categories set updated_at = current_timestamp where id = old.id;
            end;
      """);

      await db.execute("""
        create table $QuotesTable(
          id integer primary key, 
          server_id integer null,
          category_id integer null,
        
          content TEXT,
          author varchar(50),
        
          created_at timestamp default current_timestamp,
          updated_at timestamp default current_timestamp,
                
          foreign key(category_id) references Categories(id)
        );
      """);

      await db.execute("""
        create trigger quotes_on_update
          after update on Quotes
          begin
            update Quotes set updated_at = current_timestamp where id = old.id;
          end;
      """);

      await db.execute("""
        create trigger quotes_on_category_delete
          after delete on Categories
            for each row
            begin
              delete from Quotes where category_id = old.id;
            end;
      """);

      await db.execute("""
        create table $FavoritesTable(
          id integer primary key, 
          server_id integer null,
          quote_id integer unique,
        
          created_at timestamp default current_timestamp,
          updated_at timestamp default current_timestamp,
        
          foreign key(quote_id) references Quotes(id)
        );
      """);

      await db.execute("""
        create trigger favorites_on_update
          after update on Favorites
            begin
              update Favorites set updated_at = current_timestamp where id = old.id;
            end;
      """);
    },
    version: 1,
  );

  return database;
}
