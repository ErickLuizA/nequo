import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_state.dart';
import 'package:nequo/presentation/random_details/widgets/favorite_button.dart';
import 'package:nequo/presentation/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void handleFavorite(Quote fav, int index) {}
}

class MethodsMock extends Mock implements Methods {}

class FavoriteBlocMock extends Mock implements FavoriteBloc {}

void main() {
  final methodsMock = MethodsMock();
  final state = SuccessState(
    quotes: [Quote(author: 'author', content: 'content', id: 1)],
    scrollPos: 0,
  );
  final current = 0;
  FavoriteBlocMock favoriteBlocMock;

  setUp(() async {
    favoriteBlocMock = FavoriteBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<FavoriteBloc>(() => favoriteBlocMock);
  });

  tearDown(() async {
    favoriteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('render FavoriteButton', (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        BlocProvider(
          create: (_) => sl.getIt<FavoriteBloc>(),
          child: FavoriteButton(
            current: current,
            handleFavorite: methodsMock.handleFavorite,
            state: state,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("favorite_button_bloc_builder")), findsOneWidget);
  });

  testWidgets('should call handleFavorite function when button is pressed',
      (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        BlocProvider(
          create: (_) => sl.getIt<FavoriteBloc>(),
          child: FavoriteButton(
            current: current,
            handleFavorite: methodsMock.handleFavorite,
            state: state,
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("no_fav_button")));

    verify(methodsMock.handleFavorite(any, any)).called(1);
  });
}
