import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  DeleteFavorite deleteFavorite;
  MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    deleteFavorite =
        DeleteFavorite(favoritesRepository: mockFavoritesRepository);
  });

  final params = DeleteFavoriteParams(id: 1);

  test('should call FavoritesRepository.deleteFavorite with given params',
      () async {
    await deleteFavorite(params);

    verify(mockFavoritesRepository.deleteFavorite(params));
    verifyNoMoreInteractions(mockFavoritesRepository);
  });

  test('should return a Failure from repository', () async {
    when(mockFavoritesRepository.deleteFavorite(params))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await deleteFavorite(params);

    expect(result, equals(Left(CacheFailure())));
  });
}
