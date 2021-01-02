import 'dart:convert';
import 'package:NeQuo/data/models/quote_list_model.dart';
import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/domain/errors/exceptions.dart';
import 'package:NeQuo/data/models/quote_model.dart';
import 'package:NeQuo/domain/usecases/add_quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote_list.dart';
import 'package:NeQuo/domain/usecases/load_quotes.dart';
import 'package:NeQuo/external/datasources/quote_local_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../utils/random_json.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockDatabase extends Mock implements Database {}

void main() {
  QuoteLocalDatasourceImpl quoteLocalDatasourceImpl;
  MockSharedPreferences mockSharedPreferences;
  MockDatabase mockDatabase;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockDatabase = MockDatabase();
    quoteLocalDatasourceImpl = QuoteLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
      database: mockDatabase,
    );
  });

  final randomQuoteModel = QuoteModel(
    author: 'author',
    content: 'content',
  );
  final quotesParams = LoadQuotesParams(id: 1);
  final quoteListParams = QuoteList(name: 'name');
  final addQuoteParams =
      AddQuoteParams(listId: 1, author: 'author', content: 'content');
  final deleteQuoteParams = DeleteQuoteParams(id: 1);
  final deleteQuoteListParams = DeleteQuoteListParams(id: 1);

  test('should call SharedPreferences to cache the data', () async {
    await quoteLocalDatasourceImpl.cacheQuote(randomQuoteModel);

    final expectedJson = jsonEncode(randomQuoteModel.toMap());

    verify(mockSharedPreferences.setString(CACHE_QUOTE, expectedJson));
  });

  group('GetLastQuote', () {
    test('should return quote from SharedPreferences', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(randomJsonResponse);

      final result = await quoteLocalDatasourceImpl.getLastQuote();

      verify(mockSharedPreferences.getString(CACHE_QUOTE));
      expect(
          result, equals(QuoteModel.fromMap(jsonDecode(randomJsonResponse))));
    });

    test('should throw cacheException when there is no local data', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      expect(() => quoteLocalDatasourceImpl.getLastQuote(),
          throwsA(isA<CacheException>()));
    });
  });

  group('GetCachedQuoteList', () {
    test('should call database with the given params', () async {
      when(mockDatabase.query('QuoteList'))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      await quoteLocalDatasourceImpl.getCachedQuoteList();

      verify(mockDatabase.query('QuoteList'));
      verifyNoMoreInteractions(mockDatabase);
    });

    test('should return a QuoteList if database successfully get it', () async {
      when(mockDatabase.query('QuoteList'))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      final result = await quoteLocalDatasourceImpl.getCachedQuoteList();

      expect(result, isA<List<QuoteListModel>>());
    });
  });

  group('GetCachedQuotes', () {
    test('should call database with the given params', () async {
      when(mockDatabase.query('Quotes', where: 'listId = ?', whereArgs: [1]))
          .thenAnswer((realInvocation) async => List<Map<String, dynamic>>());

      await quoteLocalDatasourceImpl.getCachedQuotes(quotesParams);

      verify(mockDatabase.query('Quotes', where: 'listId = ?', whereArgs: [1]));
      verifyNoMoreInteractions(mockDatabase);
    });

    test('should return a QuoteList if database successfully get it', () async {
      when(mockDatabase.query('Quotes', where: 'listId = ?', whereArgs: [1]))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      final result =
          await quoteLocalDatasourceImpl.getCachedQuotes(quotesParams);

      expect(result, isA<List<QuoteModel>>());
    });
  });

  group('AddQuoteList', () {
    test('should call database with the given  params', () async {
      when(mockDatabase.insert(
        'QuoteList',
        QuoteListModel(name: 'name').toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      )).thenReturn(null);

      await quoteLocalDatasourceImpl.addQuoteList(quoteListParams);

      verify(mockDatabase.insert(
        'QuoteList',
        QuoteListModel(name: 'name').toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      ));

      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to insert data',
        () async {
      when(mockDatabase.insert(
        'QuoteList',
        QuoteListModel(name: 'name').toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      )).thenThrow(Exception());

      expect(() => quoteLocalDatasourceImpl.addQuoteList(quoteListParams),
          throwsA(isA<CacheException>()));
    });
  });

  group('AddQuote', () {
    test('should call database with the given  params', () async {
      when(mockDatabase.insert(
        'Quotes',
        QuoteModel(
          listId: addQuoteParams.listId,
          content: addQuoteParams.content,
          author: addQuoteParams.author,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).thenReturn(null);

      await quoteLocalDatasourceImpl.addQuote(addQuoteParams);

      verify(mockDatabase.insert(
        'Quotes',
        QuoteModel(
          listId: addQuoteParams.listId,
          content: addQuoteParams.content,
          author: addQuoteParams.author,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ));

      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to insert data',
        () async {
      when(mockDatabase.insert(
        'Quotes',
        QuoteModel(
          listId: addQuoteParams.listId,
          content: addQuoteParams.content,
          author: addQuoteParams.author,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).thenThrow(Exception());

      expect(() => quoteLocalDatasourceImpl.addQuote(addQuoteParams),
          throwsA(isA<CacheException>()));
    });
  });

  group('DeleteQuote', () {
    test('should call database with the given  params', () async {
      when(mockDatabase.delete(
        'Quotes',
        where: "id = ?",
        whereArgs: [1],
      )).thenReturn(null);

      await quoteLocalDatasourceImpl.deleteQuote(deleteQuoteParams);

      verify(mockDatabase.delete(
        'Quotes',
        where: "id = ?",
        whereArgs: [1],
      ));

      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to insert data',
        () async {
      when(mockDatabase.delete(
        'Quotes',
        where: "id = ?",
        whereArgs: [1],
      )).thenThrow(Exception());

      expect(() => quoteLocalDatasourceImpl.deleteQuote(deleteQuoteParams),
          throwsA(isA<CacheException>()));
    });
  });

  group('DeleteQuoteList', () {
    test('should call database with the given  params', () async {
      when(mockDatabase.delete(
        'QuoteList',
        where: "id = ?",
        whereArgs: [1],
      )).thenReturn(null);

      await quoteLocalDatasourceImpl.deleteQuoteList(deleteQuoteListParams);

      verify(mockDatabase.delete(
        'QuoteList',
        where: "id = ?",
        whereArgs: [1],
      ));

      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to insert data',
        () async {
      when(mockDatabase.delete(
        'QuoteList',
        where: "id = ?",
        whereArgs: [1],
      )).thenThrow(Exception());

      expect(
          () => quoteLocalDatasourceImpl.deleteQuoteList(deleteQuoteListParams),
          throwsA(isA<CacheException>()));
    });
  });
}
