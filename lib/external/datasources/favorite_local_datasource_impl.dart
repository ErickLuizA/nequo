import 'package:nequo/data/models/favorite_model.dart';
import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';

import 'package:nequo/data/datasources/favorite_local_datasource.dart';
import 'package:sqflite/sqlite_api.dart';

class FavoriteLocalDatasourceImpl implements FavoriteLocalDatasource {
  final Database database;

  FavoriteLocalDatasourceImpl({
    required this.database,
  });

  @override
  Future<void> addFavorite(Favorite params) async {
    try {
      await database.insert(
        'Favorites',
        FavoriteModel(
          author: params.author,
          content: params.content,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    try {
      final result = await database.query('Favorites');

      return List.generate(result.length, (i) {
        return FavoriteModel.fromMap(result[i]);
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteFavorite(DeleteFavoriteParams params) async {
    try {
      await database.delete(
        'Favorites',
        where: "id = ?",
        whereArgs: [params.id],
      );
    } catch (e) {
      throw CacheException();
    }
  }
}
