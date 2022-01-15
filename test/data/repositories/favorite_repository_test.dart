import 'package:nequo/data/datasources/favorite_local_datasource.dart';
import 'package:nequo/data/models/favorite_model.dart';
import 'package:nequo/data/repositories/favorite_repository_impl.dart';
import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteLocalDatasource extends Mock
    implements FavoriteLocalDatasource {}

void main() {
  FavoriteRepositoryImpl favoriteRepositoryImpl;
  MockFavoriteLocalDatasource mockFavoriteLocalDatasource;

  setUp(() {
    mockFavoriteLocalDatasource = MockFavoriteLocalDatasource();
    favoriteRepositoryImpl = FavoriteRepositoryImpl(
        favoriteLocalDatasource: mockFavoriteLocalDatasource);
  });

  final favParams = Favorite(
    content: 'content',
    author: 'author',
  );

  final delParams = DeleteFavoriteParams(id: 1);

  group('AddFavorite', () {
    test('should call the local datasource with given params', () async {
      await favoriteRepositoryImpl.addFavorite(favParams);

      verify(mockFavoriteLocalDatasource.addFavorite(favParams));
      verifyNoMoreInteractions(mockFavoriteLocalDatasource);
    });

    test('should return a Failure when datasource throws cacheException',
        () async {
      when(mockFavoriteLocalDatasource.addFavorite(any))
          .thenThrow(CacheException());

      final result = await favoriteRepositoryImpl.addFavorite(favParams);

      expect(result, isA<Left<Failure, void>>());
    });
  });

  group('GetFavorites', () {
    test('should return Right on succes', () async {
      when(mockFavoriteLocalDatasource.getFavorites())
          .thenAnswer((_) async => List<FavoriteModel>());

      final result = await favoriteRepositoryImpl.getFavorites();

      expect(result, isA<Right<Failure, List<Favorite>>>());
    });

    test('should throw a Failure when datasource throws cacheException',
        () async {
      when(mockFavoriteLocalDatasource.getFavorites())
          .thenThrow(CacheException());

      final result = await favoriteRepositoryImpl.getFavorites();

      expect(result, isA<Left<Failure, List<Favorite>>>());
    });
  });

  group('DeleteFavorite', () {
    test('should call the local datasource with given params', () async {
      await favoriteRepositoryImpl.deleteFavorite(delParams);

      verify(mockFavoriteLocalDatasource.deleteFavorite(delParams));
      verifyNoMoreInteractions(mockFavoriteLocalDatasource);
    });

    test('should throw a Failure when datasource throws cacheException',
        () async {
      when(mockFavoriteLocalDatasource.deleteFavorite(delParams))
          .thenThrow(CacheException());

      final result = await favoriteRepositoryImpl.deleteFavorite(delParams);

      expect(result, isA<Left<Failure, void>>());
    });
  });
}
