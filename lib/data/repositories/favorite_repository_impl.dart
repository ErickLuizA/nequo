import 'package:dartz/dartz.dart';
import 'package:nequo/data/datasources/favorites_local_datasource.dart';
import 'package:nequo/data/datasources/quotes_local_datasource.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/load_quote.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesLocalDatasource favoritesLocalDatasource;
  QuotesLocalDatasource quotesLocalDatasource;

  FavoritesRepositoryImpl(
      {required this.favoritesLocalDatasource,
      required this.quotesLocalDatasource});

  @override
  Future<Either<Failure, List<Quote>>> findAll() async {
    try {
      final result = await favoritesLocalDatasource.findAll();

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Quote>> findOne(LoadQuoteParams params) async {
    try {
      final result = await favoritesLocalDatasource.findOne(id: params.id);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Quote>> save(AddFavoriteParams params) async {
    try {
      try {
        await quotesLocalDatasource.findOne(id: params.quote.id);
      } on CacheException {
        await quotesLocalDatasource.save(
          params: AddQuoteParams(
            id: params.quote.id,
            content: params.quote.content,
            author: params.quote.author,
            authorSlug: params.quote.authorSlug,
          ),
        );
      }

      final result = await favoritesLocalDatasource.save(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(DeleteFavoriteParams params) async {
    try {
      final result = await favoritesLocalDatasource.delete(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
