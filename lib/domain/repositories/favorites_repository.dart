import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:dartz/dartz.dart';
import 'package:nequo/domain/usecases/load_quote.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, Quote>> findOne(LoadQuoteParams params);

  Future<Either<Failure, List<Quote>>> findAll();

  Future<Either<Failure, Quote>> save(AddFavoriteParams params);

  Future<Either<Failure, void>> delete(DeleteFavoriteParams params);
}
