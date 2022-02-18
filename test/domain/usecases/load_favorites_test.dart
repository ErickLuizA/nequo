import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/domain/usecases/load_favorites.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  LoadFavorites loadFavorites;
  MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    loadFavorites = LoadFavorites(favoritesRepository: mockFavoritesRepository);
  });
  test('should call FavoritesRepository.getFavorites with given params',
      () async {
    await loadFavorites(NoParams());

    verify(mockFavoritesRepository.getFavorites());
    verifyNoMoreInteractions(mockFavoritesRepository);
  });

  test('should return a List<Quote> from repository', () async {
    when(mockFavoritesRepository.getFavorites())
        .thenAnswer((_) async => Right(List<Quote>()));

    final result = await loadFavorites(NoParams());

    expect(result, isA<Right<Failure, List<Quote>>>());
  });

  test('should return a Failure from repository', () async {
    when(mockFavoritesRepository.getFavorites())
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await loadFavorites(NoParams());

    expect(result, equals(Left(CacheFailure())));
  });
}
