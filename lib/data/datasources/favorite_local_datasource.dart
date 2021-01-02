import 'package:NeQuo/data/models/favorite_model.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/usecases/delete_favorite.dart';

abstract class FavoriteLocalDatasource {
  Future<void> addFavorite(Favorite params);

  Future<List<FavoriteModel>> getFavorites();

  Future<void> deleteFavorite(DeleteFavoriteParams params);
}
