import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/usecases/delete_favorite.dart';
import 'package:NeQuo/domain/usecases/load_favorites.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_bloc.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_event.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoadFavorites extends Mock implements LoadFavorites {}

class MockDeleteFavorite extends Mock implements DeleteFavorite {}

void main() {
  FavoritesBloc favoritesBloc;
  MockLoadFavorites mockLoadFavorites;
  MockDeleteFavorite mockDeleteFavorite;

  setUp(() {
    mockLoadFavorites = MockLoadFavorites();
    mockDeleteFavorite = MockDeleteFavorite();
    favoritesBloc = FavoritesBloc(
      loadFavorites: mockLoadFavorites,
      deleteFavorite: mockDeleteFavorite,
    );
  });

  final deleteFavoriteParams = DeleteFavoriteParams(id: 1);

  group('GetFavorites', () {
    test(
        'should emit Loading and Empty in order when data gotten successfully but is Empty',
        () async {
      when(mockLoadFavorites(any))
          .thenAnswer((_) async => Right(List<Favorite>()));

      expect(
        favoritesBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<EmptyState>(),
        ]),
      );

      favoritesBloc.add(
        GetFavorites(),
      );
    });

    test(
        'should emit Loading and Success in order when data gotten successfully',
        () async {
      when(mockLoadFavorites(any)).thenAnswer(
          (_) async => Right([Favorite(author: 'a', content: 'a')]));

      expect(
        favoritesBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<SuccessState>(),
        ]),
      );

      favoritesBloc.add(
        GetFavorites(),
      );
    });

    test('should emit Loading and Error in order when getting data fails',
        () async {
      when(mockLoadFavorites(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      expect(
        favoritesBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<ErrorState>(),
        ]),
      );

      favoritesBloc.add(
        GetFavorites(),
      );
    });
  });

  group('DeleteFavoriteEvent', () {
    test(
        'should emit Loading, Loading and Success in order when returns is Right',
        () async {
      when(mockDeleteFavorite(any)).thenAnswer((_) async => Right(null));
      when(mockLoadFavorites(any)).thenAnswer(
          (_) async => Right([Favorite(author: 'a', content: 'a')]));

      expect(
        favoritesBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<LoadingState>(),
          isA<SuccessState>(),
        ]),
      );

      favoritesBloc.add(
        DeleteFavoriteEvent(
          params: deleteFavoriteParams,
        ),
      );
    });

    test(
        'should emit Loading, Loading and Error in order when getting data fails',
        () async {
      when(mockDeleteFavorite(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      when(mockLoadFavorites(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      expect(
        favoritesBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<FailedState>(),
          isA<LoadingState>(),
          isA<ErrorState>(),
        ]),
      );

      favoritesBloc.add(
        DeleteFavoriteEvent(
          params: deleteFavoriteParams,
        ),
      );
    });
  });
}
