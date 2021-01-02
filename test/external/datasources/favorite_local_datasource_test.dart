import 'package:NeQuo/data/models/favorite_model.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/errors/exceptions.dart';
import 'package:NeQuo/domain/usecases/delete_favorite.dart';
import 'package:NeQuo/external/datasources/favorite_local_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  FavoriteLocalDatasourceImpl favoriteLocalDatasourceImpl;
  MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    favoriteLocalDatasourceImpl =
        FavoriteLocalDatasourceImpl(database: mockDatabase);
  });

  final params = Favorite(author: 'author', content: 'content');
  final delParams = DeleteFavoriteParams(id: 1);

  group('AddFavorite', () {
    test('should call the database.insert method with given params', () async {
      await favoriteLocalDatasourceImpl.addFavorite(params);

      verify(mockDatabase.insert(
        'Favorites',
        FavoriteModel(
          author: params.author,
          content: params.content,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ));
      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to insert data',
        () async {
      when(mockDatabase.insert(
        any,
        any,
        conflictAlgorithm: ConflictAlgorithm.replace,
      )).thenThrow(Exception());

      expect(() => favoriteLocalDatasourceImpl.addFavorite(params),
          throwsA(isA<CacheException>()));
    });
  });

  group('GetFavorites', () {
    test('should call the database.query method ', () async {
      when(mockDatabase.query('Favorites'))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      await favoriteLocalDatasourceImpl.getFavorites();

      verify(mockDatabase.query('Favorites'));
      verifyNoMoreInteractions(mockDatabase);
    });

    test('should return List<FavoriteModel> if query is successfull ',
        () async {
      when(mockDatabase.query('Favorites'))
          .thenAnswer((_) async => List<Map<String, dynamic>>());

      final result = await favoriteLocalDatasourceImpl.getFavorites();

      expect(result, isA<List<FavoriteModel>>());
    });

    test('should throw CacheException if database fails to return data',
        () async {
      when(mockDatabase.query('Favorites')).thenThrow(CacheException());

      expect(() => favoriteLocalDatasourceImpl.getFavorites(),
          throwsA(isA<CacheException>()));
    });
  });

  group('DeleteFavorite', () {
    test('should call the database.delete method with given params', () async {
      await favoriteLocalDatasourceImpl.deleteFavorite(delParams);

      verify(
        mockDatabase.delete(
          'Favorites',
          where: "id = ?",
          whereArgs: [delParams.id],
        ),
      );
      verifyNoMoreInteractions(mockDatabase);
    });

    test('should throw CacheException if database fails to delete data',
        () async {
      when(mockDatabase.delete(
        'Favorites',
        where: "id = ?",
        whereArgs: [1],
      )).thenThrow(Exception());
      expect(() => favoriteLocalDatasourceImpl.deleteFavorite(delParams),
          throwsA(isA<CacheException>()));
    });
  });
}
