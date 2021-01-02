import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/favorite_repository.dart';
import 'package:NeQuo/domain/usecases/add_favorite.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  AddFavorite addFavorite;
  MockFavoriteRepository mockFavoriteRepository;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    addFavorite = AddFavorite(favoriteRepository: mockFavoriteRepository);
  });

  final favParams = Favorite(
    content: 'content',
    author: 'author',
  );

  test('should call addFavorite methods in the repository with given params',
      () async {
    await addFavorite(favParams);

    verify(mockFavoriteRepository.addFavorite(favParams));
    verifyNoMoreInteractions(mockFavoriteRepository);
  });

  test('should return a CacheFailure from repository', () async {
    when(mockFavoriteRepository.addFavorite(favParams))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await addFavorite(favParams);

    expect(result, equals(Left(CacheFailure())));
  });
}
