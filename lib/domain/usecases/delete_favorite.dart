import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/favorite_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

class DeleteFavoriteParams {
  int id;

  DeleteFavoriteParams({
    @required this.id,
  });
}

class DeleteFavorite extends UseCase<void, DeleteFavoriteParams> {
  FavoriteRepository favoriteRepository;

  DeleteFavorite({
    this.favoriteRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeleteFavoriteParams params) async {
    return await favoriteRepository.deleteFavorite(params);
  }
}
