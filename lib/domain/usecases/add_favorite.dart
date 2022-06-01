import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class AddFavoriteParams {
  final Quote quote;

  AddFavoriteParams({required this.quote});
}

class AddFavorite implements UseCase<void, AddFavoriteParams> {
  final FavoritesRepository favoritesRepository;

  AddFavorite({
    required this.favoritesRepository,
  });

  @override
  Future<Either<Failure, Quote>> call(AddFavoriteParams params) async {
    return await favoritesRepository.save(params);
  }
}
