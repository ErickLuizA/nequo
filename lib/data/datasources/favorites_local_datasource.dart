import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';

abstract class FavoritesLocalDatasource {
  Future<Quote> findOne({required int id});

  Future<List<Quote>> findAll();

  Future<Quote> save(AddFavoriteParams params);

  Future<void> delete(DeleteFavoriteParams params);
}
