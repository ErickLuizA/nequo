import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:dartz/dartz.dart';

import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/favorite_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';
import 'package:flutter/material.dart';

class LoadFavorites implements UseCase<List<Favorite>, NoParams> {
  final FavoriteRepository favoriteRepository;

  LoadFavorites({
    @required this.favoriteRepository,
  });

  @override
  Future<Either<Failure, List<Favorite>>> call(NoParams params) async {
    return await favoriteRepository.getFavorites();
  }
}
