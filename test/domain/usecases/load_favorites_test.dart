import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorite_repository.dart';
import 'package:nequo/domain/usecases/load_favorites.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  LoadFavorites loadFavorites;
  MockFavoriteRepository mockFavoriteRepository;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    loadFavorites = LoadFavorites(favoriteRepository: mockFavoriteRepository);
  });
  test('should call FavoriteRepository.getFavorites with given params',
      () async {
    await loadFavorites(NoParams());

    verify(mockFavoriteRepository.getFavorites());
    verifyNoMoreInteractions(mockFavoriteRepository);
  });

  test('should return a List<Favorite> from repository', () async {
    when(mockFavoriteRepository.getFavorites())
        .thenAnswer((_) async => Right(List<Favorite>()));

    final result = await loadFavorites(NoParams());

    expect(result, isA<Right<Failure, List<Favorite>>>());
  });

  test('should return a Failure from repository', () async {
    when(mockFavoriteRepository.getFavorites())
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await loadFavorites(NoParams());

    expect(result, equals(Left(CacheFailure())));
  });
}
