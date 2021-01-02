import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/usecases/delete_favorite.dart';
import 'package:dartz/dartz.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, void>> addFavorite(Favorite params);

  Future<Either<Failure, List<Favorite>>> getFavorites();

  Future<Either<Failure, void>> deleteFavorite(DeleteFavoriteParams params);
}
