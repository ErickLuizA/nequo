import 'package:nequo/data/models/favorite_model.dart';
import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';

abstract class FavoriteLocalDatasource {
  Future<void> addFavorite(Favorite params);

  Future<List<FavoriteModel>> getFavorites();

  Future<void> deleteFavorite(DeleteFavoriteParams params);
}
