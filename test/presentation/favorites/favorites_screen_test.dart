import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/presentation/favorites/bloc/favorites_bloc.dart';
import 'package:nequo/presentation/favorites/bloc/favorites_state.dart';
import 'package:nequo/presentation/favorites/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nequo/service_locator.dart' as sl;
import 'package:mockito/mockito.dart';

import '../../utils/make_app.dart';

class FavoritesBlocMock extends Mock implements FavoritesBloc {}

void main() {
  FavoritesBlocMock favoritesBlocMock;

  setUp(() async {
    favoritesBlocMock = FavoritesBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<FavoritesBloc>(() => favoritesBlocMock);
  });

  tearDown(() async {
    favoritesBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('renders screen', (tester) async {
    await tester.pumpWidget(makeApp(FavoritesScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("favorites_screen")), findsOneWidget);
  });

  testWidgets('renders empty widget when EmptyState is returned from bloc',
      (tester) async {
    when(favoritesBlocMock.state).thenAnswer((_) => EmptyState());

    await tester.pumpWidget(makeApp(FavoritesScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("empty_widget")), findsOneWidget);
  });

  testWidgets(
      'renders load_widget_failure widget when FailedState is returned from bloc',
      (tester) async {
    when(favoritesBlocMock.state).thenAnswer((_) => FailedState());

    await tester.pumpWidget(makeApp(FavoritesScreen()));
    await tester.pump();

    expect(find.byKey(Key("loading_widget_failure")), findsOneWidget);

    await tester.pump();

    expect(find.byKey(Key("failed_snackbar")), findsOneWidget);
  });

  testWidgets('renders loading when LoadingState is returned from bloc',
      (tester) async {
    when(favoritesBlocMock.state).thenAnswer((_) => LoadingState());

    await tester.pumpWidget(makeApp(FavoritesScreen()));
    await tester.pump();

    expect(find.byKey(Key("loading_widget")), findsOneWidget);
  });

  testWidgets('renders success_widget when SuccessState is returned from bloc',
      (tester) async {
    when(favoritesBlocMock.state).thenAnswer(
      (_) => SuccessState(
          favorites: [Favorite(author: 'author', content: 'content', id: 1)]),
    );

    await tester.pumpWidget(makeApp(FavoritesScreen()));
    await tester.pump();

    expect(find.byKey(Key("success_widget")), findsOneWidget);
  });

  testWidgets(
      'renders error_widget when error or no state is returned from bloc',
      (tester) async {
    await tester.pumpWidget(makeApp(FavoritesScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_error_widget")), findsOneWidget);
  });
}
