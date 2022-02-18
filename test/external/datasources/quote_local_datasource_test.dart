import 'dart:convert';
import 'package:nequo/data/models/category_model.dart';
import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/data/models/quote_model.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/delete_category.dart';
import 'package:nequo/domain/usecases/load_quote.dart';
import 'package:nequo/external/datasources/quote_local_datasource_impl.dart';
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

  final randomQuoteModel = Quote(
    author: 'author',
    content: 'content',
  );
  final quotesParams = LoadQuotesParams(id: 1);
  final quoteListParams = Category(name: 'name');
  final addQuoteParams =
      AddQuoteParams(categoryId: 1, author: 'author', content: 'content');
  final deleteQuoteParams = DeleteQuoteParams(id: 1);
  final deleteCategoryParams = DeleteCategoryParams(id: 1);

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
      expect(result, equals(Quote.fromMap(jsonDecode(randomJsonResponse))));
    });

    test('should throw cacheException when there is no local data', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      expect(() => quoteLocalDatasourceImpl.getLastQuote(),
          throwsA(isA<CacheException>()));
    });
  });

  group('GetCachedCategory', () {
    test('should call database with the given params', () async {
      when(mockDatabase.query('Category'))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      await quoteLocalDatasourceImpl.getCachedCategory();

      verify(mockDatabase.query('Category'));
      verifyNoMoreInteractions(mockDatabase);
    });

    test('should return a Category if database successfully get it', () async {
      when(mockDatabase.query('Category'))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      final result = await quoteLocalDatasourceImpl.getCachedCategory();

      expect(result, isA<List<Category>>());
    });
  });

  group('GetCachedQuotes', () {
    test('should call database with the given params', () async {
      when(mockDatabase
              .query('Quotes', where: 'categoryId = ?', whereArgs: [1]))
          .thenAnswer((realInvocation) async => List<Map<String, dynamic>>());

      await quoteLocalDatasourceImpl.getCachedQuotes(quotesParams);

      verify(mockDatabase
          .query('Quotes', where: 'categoryId = ?', whereArgs: [1]));
      verifyNoMoreInteractions(mockDatabase);
    });

    test('should return a Category if database successfully get it', () async {
      when(mockDatabase
              .query('Quotes', where: 'categoryId = ?', whereArgs: [1]))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      final result =
          await quoteLocalDatasourceImpl.getCachedQuotes(quotesParams);

      expect(result, isA<List<Quote>>());
    });
  });

  group('AddCategory', () {
    test('should call database with the given  params', () async {
      when(mockDatabase.insert(
        'Category',
        Category(name: 'name').toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      )).thenReturn(null);

      await quoteLocalDatasourceImpl.addCategory(quoteListParams);

      verify(mockDatabase.insert(
        'Category',
        Category(name: 'name').toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      ));

      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to insert data',
        () async {
      when(mockDatabase.insert(
        'Category',
        Category(name: 'name').toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      )).thenThrow(Exception());

      expect(() => quoteLocalDatasourceImpl.addCategory(quoteListParams),
          throwsA(isA<CacheException>()));
    });
  });

  group('AddQuote', () {
    test('should call database with the given  params', () async {
      when(mockDatabase.insert(
        'Quotes',
        Quote(
          categoryId: addQuoteParams.categoryId,
          content: addQuoteParams.content,
          author: addQuoteParams.author,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).thenReturn(null);

      await quoteLocalDatasourceImpl.addQuote(addQuoteParams);

      verify(mockDatabase.insert(
        'Quotes',
        Quote(
          categoryId: addQuoteParams.categoryId,
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
        Quote(
          categoryId: addQuoteParams.categoryId,
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

  group('DeleteCategory', () {
    test('should call database with the given  params', () async {
      when(mockDatabase.delete(
        'Category',
        where: "id = ?",
        whereArgs: [1],
      )).thenReturn(null);

      await quoteLocalDatasourceImpl.deleteCategory(deleteCategoryParams);

      verify(mockDatabase.delete(
        'Category',
        where: "id = ?",
        whereArgs: [1],
      ));

      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to insert data',
        () async {
      when(mockDatabase.delete(
        'Category',
        where: "id = ?",
        whereArgs: [1],
      )).thenThrow(Exception());

      expect(
          () => quoteLocalDatasourceImpl.deleteCategory(deleteCategoryParams),
          throwsA(isA<CacheException>()));
    });
  });
}
