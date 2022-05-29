import 'package:nequo/data/datasources/favorites_local_datasource.dart';
import 'package:nequo/data/mappers/local/local_favorite_mapper.dart';
import 'package:nequo/data/mappers/local/local_quote_mapper.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/external/services/database/database.dart';
import 'package:sqflite/sqlite_api.dart';

class FavoriteLocalDatasourceImpl implements FavoritesLocalDatasource {
  final Database database;

  FavoriteLocalDatasourceImpl({
    required this.database,
  });

  @override
  Future<List<Quote>> findAll() async {
    try {
      final result = await database.rawQuery(
        '''
       SELECT
          Quotes.*,
          Favorites.id as favorite_id
        FROM $FavoritesTable
        JOIN Quotes ON Quotes.id = Favorites.quote_id
        ''',
      );

      return result.map((e) => LocalQuoteMapper.toEntity(e)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Quote> findOne({required int id}) async {
    try {
      final result = await database.rawQuery(
        '''
       SELECT
          Quotes.*,
          Favorites.id as favorite_id
        FROM $FavoritesTable
        JOIN Quotes ON Quotes.id = Favorites.quote_id
        WHERE Favorites.id = ?
        ''',
        [id],
      );

      if (result.isEmpty) throw CacheException();

      return LocalQuoteMapper.toEntity(result[0]);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Quote> save(AddFavoriteParams params) async {
    try {
      final id = await database.insert(
        FavoritesTable,
        LocalFavoriteMapper.toMap(quoteId: params.quoteId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return findOne(id: id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> delete(DeleteFavoriteParams params) async {
    try {
      await database.delete(
        FavoritesTable,
        where: "quote_id = ?",
        whereArgs: [params.id],
      );
    } catch (e) {
      throw CacheException();
    }
  }
}
