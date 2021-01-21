import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/presentation/details/bloc/details_state.dart';
import 'package:NeQuo/presentation/details/widgets/favorite_button.dart';
import 'package:NeQuo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:NeQuo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void handleFavorite(Favorite fav, int index) {}
}

class MethodsMock extends Mock implements Methods {}

class FavoriteBlocMock extends Mock implements FavoriteBloc {}

void main() {
  MethodsMock methodsMock;
  FavoriteBlocMock favoriteBlocMock;
  SuccessState state;
  int current = 0;

  setUp(() async {
    methodsMock = MethodsMock();
    favoriteBlocMock = FavoriteBlocMock();
    state = SuccessState(
        quotes: [Quote(author: 'author', content: 'content', id: 1)]);

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<FavoriteBloc>(() => favoriteBlocMock);
  });

  tearDown(() async {
    favoriteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('render FavoriteButton', (tester) async {
    when(favoriteBlocMock.state)
        .thenAnswer((_) => FavoriteSuccessState(favIndex: [0]));

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: FavoriteButton(
              current: current,
              handleFavorite: methodsMock.handleFavorite,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("favorite_button_bloc_builder")), findsOneWidget);
  });

  testWidgets('render yes_fav_button when isFavorite', (tester) async {
    when(favoriteBlocMock.state)
        .thenAnswer((_) => FavoriteSuccessState(favIndex: [0]));

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: FavoriteButton(
              current: current,
              handleFavorite: methodsMock.handleFavorite,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("yes_fav_button")), findsOneWidget);
  });

  testWidgets('render no_fav_button when is not Favorite', (tester) async {
    when(favoriteBlocMock.state)
        .thenAnswer((_) => FavoriteSuccessState(favIndex: [1]));

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: FavoriteButton(
              current: current,
              handleFavorite: methodsMock.handleFavorite,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("no_fav_button")), findsOneWidget);
  });

  testWidgets('should call handleFavorite when button is pressed',
      (tester) async {
    when(favoriteBlocMock.state)
        .thenAnswer((_) => FavoriteSuccessState(favIndex: [1]));

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: FavoriteButton(
              current: current,
              handleFavorite: methodsMock.handleFavorite,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("no_fav_button")));

    verify(methodsMock.handleFavorite(any, current)).called(1);
  });
}
