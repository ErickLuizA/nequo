import 'package:dartz/dartz.dart';
import 'package:nequo/data/datasources/quotes_local_datasource.dart';
import 'package:nequo/data/datasources/quotes_remote_datasource.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/services/network_info_service.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/load_quote.dart';
import 'package:nequo/domain/usecases/update_quote.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuotesRemoteDatasource quotesRemoteDatasource;
  final QuotesLocalDatasource quotesLocalDatasource;
  final NetworkInfoService networkInfoService;

  QuoteRepositoryImpl({
    required this.quotesRemoteDatasource,
    required this.quotesLocalDatasource,
    required this.networkInfoService,
  });

  @override
  Future<Either<Failure, Quote>> findQuoteOfTheDay() async {
    if (await networkInfoService.isConnected) {
      return await findQuoteOfTheDayOnline();
    } else {
      return await findQuoteOfTheDayOffline();
    }
  }

  Future<Either<Failure, Quote>> findQuoteOfTheDayOnline() async {
    try {
      final result = await quotesRemoteDatasource.findQuoteOfTheDay();

      await quotesLocalDatasource.saveQuoteOfTheDay(
        serverId: result.id,
        params: AddQuoteParams(
          content: result.content,
          author: result.author,
        ),
      );

      return findQuoteOfTheDayOffline();
    } on ServerException {
      return findQuoteOfTheDayOffline();
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<Either<Failure, Quote>> findQuoteOfTheDayOffline() async {
    try {
      final result = await quotesLocalDatasource.findQuoteOfTheDay();

      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Quote>> findOne(LoadQuoteParams params) async {
    try {
      final result = await quotesLocalDatasource.findOne(id: params.id);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Quote>>> findAll() async {
    try {
      final result = await quotesLocalDatasource.findAll();

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Quote>> save(AddQuoteParams params) async {
    try {
      final result = await quotesLocalDatasource.save(params: params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Quote>> update(UpdateQuoteParams params) async {
    try {
      final result = await quotesLocalDatasource.update(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(DeleteQuoteParams params) async {
    try {
      final result = await quotesLocalDatasource.delete(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
