import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  AddFavorite addFavorite;
  MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
    addFavorite = AddFavorite(favoritesRepository: mockFavoritesRepository);
  });

  final favParams = Quote(
    content: 'content',
    author: 'author',
  );

  test('should call addFavorite methods in the repository with given params',
      () async {
    await addFavorite(favParams);

    verify(mockFavoritesRepository.addFavorite(favParams));
    verifyNoMoreInteractions(mockFavoritesRepository);
  });

  test('should return a CacheFailure from repository', () async {
    when(mockFavoritesRepository.addFavorite(favParams))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await addFavorite(favParams);

    expect(result, equals(Left(CacheFailure())));
  });
}
