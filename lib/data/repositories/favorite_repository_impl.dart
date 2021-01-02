import 'package:NeQuo/data/datasources/favorite_local_datasource.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/errors/exceptions.dart';
import 'package:NeQuo/domain/usecases/delete_favorite.dart';
import 'package:dartz/dartz.dart';

import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteLocalDatasource favoriteLocalDatasource;

  FavoriteRepositoryImpl({
    this.favoriteLocalDatasource,
  });

  @override
  Future<Either<Failure, void>> addFavorite(Favorite params) async {
    try {
      final result = await favoriteLocalDatasource.addFavorite(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Favorite>>> getFavorites() async {
    try {
      final result = await favoriteLocalDatasource.getFavorites();

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteFavorite(
      DeleteFavoriteParams params) async {
    try {
      final result = await favoriteLocalDatasource.deleteFavorite(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
