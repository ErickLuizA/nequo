import 'package:dartz/dartz.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorite_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class DeleteFavoriteParams {
  int id;

  DeleteFavoriteParams({
    required this.id,
  });
}

class DeleteFavorite extends UseCase<void, DeleteFavoriteParams> {
  FavoriteRepository favoriteRepository;

  DeleteFavorite({
    required this.favoriteRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeleteFavoriteParams params) async {
    return await favoriteRepository.deleteFavorite(params);
  }
}
