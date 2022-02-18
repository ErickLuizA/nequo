import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/presentation/bloc/favorite_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAddFavorite extends Mock implements AddFavorite {}

void main() {
  FavoriteBloc favoriteBloc;
  MockAddFavorite mockAddFavorite;

  setUp(() {
    mockAddFavorite = MockAddFavorite();
    favoriteBloc = FavoriteBloc(
      addFavorite: mockAddFavorite,
    );
  });

  final favoriteParams = Quote(author: 'author', content: 'content');

  group('AddFavoriteEvent', () {
    test('should emit  Success  when use case returns Right', () async {
      when(mockAddFavorite(any)).thenAnswer((_) async => Right(null));

      expect(
        favoriteBloc,
        emitsInOrder([
          isA<FavoriteSuccessState>(),
        ]),
      );

      favoriteBloc.add(
        AddFavoriteEvent(
          favorite: favoriteParams,
        ),
      );
    });

    test('should emit Error when usecase returns left', () async {
      when(mockAddFavorite(any)).thenAnswer((_) async => Left(CacheFailure()));

      expect(
        favoriteBloc,
        emitsInOrder([
          isA<FavoriteErrorState>(),
        ]),
      );

      favoriteBloc.add(
        AddFavoriteEvent(
          favorite: favoriteParams,
        ),
      );
    });
  });
}
