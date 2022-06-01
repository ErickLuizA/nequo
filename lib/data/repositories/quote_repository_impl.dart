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
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/update_quote.dart';
import 'package:nequo/domain/usecases/usecase.dart';

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
    final bool isConnected = await networkInfoService.isConnected;

    if (isConnected) {
      return await findQuoteOfTheDayOnline();
    } else {
      return await findQuoteOfTheDayOffline();
    }
  }

  Future<Either<Failure, Quote>> findQuoteOfTheDayOnline() async {
    try {
      final result = await quotesRemoteDatasource.findQuoteOfTheDay();

      await quotesLocalDatasource.saveQuoteOfTheDay(
        params: AddQuoteParams(
          id: result.id,
          content: result.content,
          author: result.author,
          authorSlug: result.authorSlug,
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
    final bool isConnected = await networkInfoService.isConnected;

    if (isConnected) {
      return findOneOnline(params);
    } else {
      return findOneOffline(params);
    }
  }

  Future<Either<Failure, Quote>> findOneOnline(LoadQuoteParams params) async {
    try {
      if (params.isServer) {
        final isAlreadySaved = await quotesLocalDatasource.findByServerId(
          serverId: params.id,
        );

        if (isAlreadySaved != null) {
          return Right(isAlreadySaved);
        }
      }

      final result = await quotesRemoteDatasource.findOne(id: params.id);

      return Right(result);
    } on ServerException {
      return findOneOffline(params);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<Either<Failure, Quote>> findOneOffline(LoadQuoteParams params) async {
    try {
      if (params.isServer) {
        final result = await quotesLocalDatasource.findByServerId(
          serverId: params.id,
        );

        if (result == null) {
          return Left(CacheFailure(message: 'Quote not found'));
        }

        return Right(result);
      } else {
        final result = await quotesLocalDatasource.findOne(
          id: params.id,
        );

        return Right(result);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<List<Quote>>>> findAll(
      LoadQuotesParams params) async {
    final bool isConnected = await networkInfoService.isConnected;

    if (isConnected) {
      return findAllOnline(params);
    } else {
      return findAllOffline(params);
    }
  }

  Future<Either<Failure, PaginatedResponse<List<Quote>>>> findAllOnline(
      LoadQuotesParams params) async {
    try {
      final result = await quotesRemoteDatasource.findAll(params);

      List<Quote> quotes = result.data;

      if (params.persist) {
        quotes = await quotesLocalDatasource.saveAll(
          params: result.data
              .map(
                (quote) => SaveQuoteParams(
                  params: AddQuoteParams(
                    id: quote.id,
                    author: quote.author,
                    content: quote.content,
                    authorSlug: quote.authorSlug,
                  ),
                ),
              )
              .toList(),
        );
      }

      return Right(
        PaginatedResponse(
          data: quotes,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          perPage: result.perPage,
          total: result.total,
          firstPage: result.firstPage,
        ),
      );
    } on ServerException {
      if (params.page > 1) {
        return Left(CacheFailure(message: 'Server error!'));
      }

      return findAllOffline(params);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<Either<Failure, PaginatedResponse<List<Quote>>>> findAllOffline(
      LoadQuotesParams params) async {
    try {
      final result = await quotesLocalDatasource.findAll(isFeed: true);

      return Right(
        PaginatedResponse(
          data: result,
          currentPage: params.page,
          perPage: params.perPage,
          lastPage: params.page,
        ),
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
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

  @override
  Future<Either<Failure, Quote>> findRandom() async {
    try {
      final result = await quotesRemoteDatasource.findRandom();

      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
