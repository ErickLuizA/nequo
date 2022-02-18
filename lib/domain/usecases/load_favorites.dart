import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadFavorites implements UseCase<List<Quote>, NoParams> {
  final FavoritesRepository favoritesRepository;

  LoadFavorites({required this.favoritesRepository});

  @override
  Future<Either<Failure, List<Quote>>> call(NoParams params) async {
    return await favoritesRepository.findAll();
  }
}
