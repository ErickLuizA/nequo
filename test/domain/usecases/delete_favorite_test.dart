import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorite_repository.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  DeleteFavorite deleteFavorite;
  MockFavoriteRepository mockFavoriteRepository;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    deleteFavorite = DeleteFavorite(favoriteRepository: mockFavoriteRepository);
  });

  final params = DeleteFavoriteParams(id: 1);

  test('should call FavoriteRepository.deleteFavorite with given params',
      () async {
    await deleteFavorite(params);

    verify(mockFavoriteRepository.deleteFavorite(params));
    verifyNoMoreInteractions(mockFavoriteRepository);
  });

  test('should return a Failure from repository', () async {
    when(mockFavoriteRepository.deleteFavorite(params))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await deleteFavorite(params);

    expect(result, equals(Left(CacheFailure())));
  });
}
