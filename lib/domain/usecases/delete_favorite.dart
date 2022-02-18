import 'package:dartz/dartz.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class DeleteFavoriteParams {
  int id;

  DeleteFavoriteParams({required this.id});
}

class DeleteFavorite extends UseCase<void, DeleteFavoriteParams> {
  FavoritesRepository favoritesRepository;

  DeleteFavorite({
    required this.favoritesRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeleteFavoriteParams params) async {
    return await favoritesRepository.delete(params);
  }
}
