import 'package:nequo/external/services/database/database.dart';
import 'package:sqflite/sqflite.dart';

Future<void> onCreate(Database db, int version) async {
  await db.execute("""
        create table $QuotesTable(
          id integer primary key, 
          content TEXT,
          author_id int,
          author_slug varchar(50),
          is_feed boolean default false,
        
          created_at timestamp default current_timestamp,
          updated_at timestamp default current_timestamp
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
        create table $FavoritesTable(
          id integer primary key, 
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
}

Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion == 1) {
    await db.execute(''' 
        DROP TABLE IF EXISTS $QuotesTable;
        DROP TABLE IF EXISTS $FavoritesTable;
        DROP TABLE IF EXISTS QuoteList;
        ''');

    await onCreate(db, newVersion);
  }

  if (oldVersion == 2) {}
}
