import 'package:nequo/data/datasources/quote_local_datasource.dart';
import 'package:nequo/data/datasources/quote_remote_datasource.dart';
import 'package:nequo/data/models/quote_list_model.dart';
import 'package:nequo/data/repositories/quote_repository_impl.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/data/models/quote_model.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/delete_quote_list.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';
import 'package:nequo/external/services/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRemoteDatasource extends Mock implements QuoteRemoteDatasource {}

class MockQuoteLocalDatasource extends Mock implements QuoteLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  QuoteRepositoryImpl quoteRepository;
  MockQuoteRemoteDatasource mockRemoteDatasource;
  MockQuoteLocalDatasource mockLocalDatasource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockQuoteRemoteDatasource();
    mockLocalDatasource = MockQuoteLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    quoteRepository = QuoteRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      localDatasource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  final randomQuoteModel = QuoteModel(
    author: 'author',
    content: 'content',
  );

  final Quote randomQuote = randomQuoteModel;

  final randomQuoteParams = LoadRandomQuotesParams(
    skip: 0,
  );

  final quoteParams = LoadQuotesParams(id: 1);

  final addQuoteListParams = QuoteList(id: 1, name: 'name');

  final addQuoteParams = AddQuoteParams(
    content: 'content',
    author: 'author',
  );

  final deleteQuoteParams = DeleteQuoteParams(id: 1);

  final deleteQuoteListParams = DeleteQuoteListParams(id: 1);

  test(
    'should check if the device is online',
    () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      await quoteRepository.getRandom();
      verify(mockNetworkInfo.isConnected);
    },
  );

  runTestsOnline(() {
    test(
        'should return a random quote when remote datasource calls getRandom is successfull',
        () async {
      when(mockRemoteDatasource.getRandom())
          .thenAnswer((_) async => randomQuoteModel);

      final result = await quoteRepository.getRandom();

      expect(result, equals(Right(randomQuote)));
    });

    test(
        'should cache the data when remote datasource calls getRandom is successfull',
        () async {
      when(mockRemoteDatasource.getRandom())
          .thenAnswer((_) async => randomQuoteModel);

      await quoteRepository.getRandom();

      verify(mockRemoteDatasource.getRandom());
      verify(mockLocalDatasource.cacheQuote(randomQuote));
    });

    test('should return serverFailure on remote datasource exception',
        () async {
      when(mockRemoteDatasource.getRandom()).thenThrow(ServerException());

      final result = await quoteRepository.getRandom();

      verifyZeroInteractions(mockLocalDatasource);
      expect(result, isA<Left<Failure, Quote>>());
    });

    test(
        'should return a list of random quotes when remote datasource calls getQuotes is successfull',
        () async {
      when(mockRemoteDatasource.getQuotes(randomQuoteParams))
          .thenAnswer((_) async => List<QuoteModel>());

      final result = await quoteRepository.getRandomQuotes(randomQuoteParams);

      verifyZeroInteractions(mockLocalDatasource);
      expect(result, isA<Right<Failure, List<Quote>>>());
    });

    test('should return serverFailure on remote datasource exception',
        () async {
      when(mockRemoteDatasource.getQuotes(randomQuoteParams))
          .thenThrow(ServerException());

      final result = await quoteRepository.getRandomQuotes(randomQuoteParams);

      verifyZeroInteractions(mockLocalDatasource);
      expect(result, isA<Left<Failure, List<Quote>>>());
    });
  });

  runTestsOffline(() {
    test('should return last cached data', () async {
      when(mockLocalDatasource.getLastQuote())
          .thenAnswer((_) async => randomQuoteModel);

      final result = await quoteRepository.getRandom();

      verifyZeroInteractions(mockRemoteDatasource);
      expect(result, equals(Right(randomQuote)));
    });

    test('should return cacheFailure on local datasource exception', () async {
      when(mockLocalDatasource.getLastQuote()).thenThrow(CacheException());

      final result = await quoteRepository.getRandom();

      verifyZeroInteractions(mockRemoteDatasource);
      verify(mockLocalDatasource.getLastQuote());
      expect(result, isA<Left<Failure, Quote>>());
    });
  });

  test(
      'should return a list of Quote when local datasource getCachedQuotes is successfull',
      () async {
    when(mockLocalDatasource.getCachedQuotes(quoteParams))
        .thenAnswer((_) async => List<QuoteModel>());

    final result = await quoteRepository.getQuotes(quoteParams);

    expect(result, isA<Right<Failure, List<Quote>>>());
  });

  test('should return cacheFailure on local datasource exception', () async {
    when(mockLocalDatasource.getCachedQuotes(quoteParams))
        .thenThrow(CacheException());

    final result = await quoteRepository.getQuotes(quoteParams);

    expect(result, isA<Left<Failure, List<Quote>>>());
  });

  test(
      'should return a list of QuoteList when local datasource getCachedQuoteList is successfull',
      () async {
    when(mockLocalDatasource.getCachedQuoteList())
        .thenAnswer((_) async => List<QuoteListModel>());

    final result = await quoteRepository.getQuotesList();

    expect(result, isA<Right<Failure, List<QuoteList>>>());
  });

  test('should return cacheFailure on local datasource exception', () async {
    when(mockLocalDatasource.getCachedQuoteList()).thenThrow(CacheException());

    final result = await quoteRepository.getQuotesList();

    expect(result, isA<Left<Failure, List<QuoteList>>>());
  });

  test('should call addQuoteList in the localDatasource with given params',
      () async {
    await quoteRepository.addQuoteList(addQuoteListParams);

    verify(mockLocalDatasource.addQuoteList(addQuoteListParams));
    verifyNoMoreInteractions(mockLocalDatasource);
  });

  test('should return a Failure when localDatasource throws CacheException',
      () async {
    when(mockLocalDatasource.addQuoteList(any)).thenThrow(CacheException());

    final result = await quoteRepository.addQuoteList(addQuoteListParams);

    expect(result, isA<Left<Failure, void>>());
  });

  test('should call addQuote in the localDatasource with given params',
      () async {
    await quoteRepository.addQuote(addQuoteParams);

    verify(mockLocalDatasource.addQuote(addQuoteParams));
    verifyNoMoreInteractions(mockLocalDatasource);
  });

  test('should return a Failure when localDatasource throws CacheException',
      () async {
    when(mockLocalDatasource.addQuote(any)).thenThrow(CacheException());

    final result = await quoteRepository.addQuote(addQuoteParams);

    expect(result, isA<Left<Failure, void>>());
  });

  test('should call deleteQuote in the localDatasource with given params',
      () async {
    await quoteRepository.deleteQuote(deleteQuoteParams);

    verify(mockLocalDatasource.deleteQuote(deleteQuoteParams));
    verifyNoMoreInteractions(mockLocalDatasource);
  });

  test('should return a Failure when localDatasource throws CacheException',
      () async {
    when(mockLocalDatasource.deleteQuote(deleteQuoteParams))
        .thenThrow(CacheException());

    final result = await quoteRepository.deleteQuote(deleteQuoteParams);

    expect(result, isA<Left<Failure, void>>());
  });

  test('should call deleteQuoteList in the localDatasource with given params',
      () async {
    await quoteRepository.deleteQuoteList(deleteQuoteListParams);

    verify(mockLocalDatasource.deleteQuoteList(deleteQuoteListParams));
    verifyNoMoreInteractions(mockLocalDatasource);
  });

  test('should return a Failure when localDatasource throws CacheException',
      () async {
    when(mockLocalDatasource.deleteQuoteList(deleteQuoteListParams))
        .thenThrow(CacheException());

    final result = await quoteRepository.deleteQuoteList(deleteQuoteListParams);

    expect(result, isA<Left<Failure, void>>());
  });
}
