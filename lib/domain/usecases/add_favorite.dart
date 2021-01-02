import 'package:dartz/dartz.dart';

import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/favorite_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

class AddFavorite implements UseCase<void, Favorite> {
  final FavoriteRepository favoriteRepository;

  AddFavorite({
    this.favoriteRepository,
  });

  @override
  Future<Either<Failure, void>> call(Favorite params) async {
    return await favoriteRepository.addFavorite(params);
  }
}
