import 'package:dartz/dartz.dart';

import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorite_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class AddFavorite implements UseCase<void, Favorite> {
  final FavoriteRepository favoriteRepository;

  AddFavorite({
    required this.favoriteRepository,
  });

  @override
  Future<Either<Failure, void>> call(Favorite params) async {
    return await favoriteRepository.addFavorite(params);
  }
}
