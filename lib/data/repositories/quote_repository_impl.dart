import 'package:nequo/data/datasources/quote_local_datasource.dart';
import 'package:nequo/data/datasources/quote_remote_datasource.dart';
import 'package:nequo/data/models/quote_model.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote_list.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';
import 'package:nequo/external/services/network_info.dart';
import 'package:dartz/dartz.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDatasource remoteDatasource;
  final QuoteLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  QuoteRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Quote>> getRandom() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getRandom();
        await localDatasource.cacheQuote(result);

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await localDatasource.getLastQuote();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Quote>>> getRandomQuotes(
      LoadRandomQuotesParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDatasource.getQuotes(params);

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final List<QuoteModel> list = [];

        final result = await localDatasource.getLastQuote();

        list.add(result);

        return Right(list);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Quote>>> getQuotes(
      LoadQuotesParams params) async {
    try {
      final result = await localDatasource.getCachedQuotes(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<QuoteList>>> getQuotesList() async {
    try {
      final result = await localDatasource.getCachedQuoteList();

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addQuoteList(QuoteList params) async {
    try {
      final result = await localDatasource.addQuoteList(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addQuote(AddQuoteParams params) async {
    try {
      final result = await localDatasource.addQuote(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuote(DeleteQuoteParams params) async {
    try {
      final result = await localDatasource.deleteQuote(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuoteList(
      DeleteQuoteListParams params) async {
    try {
      final result = await localDatasource.deleteQuoteList(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
