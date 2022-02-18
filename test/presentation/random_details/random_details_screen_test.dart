import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_state.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_bloc.dart';
import 'package:nequo/presentation/random_details/random_details_screen.dart';
import 'package:nequo/presentation/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nequo/service_locator.dart' as sl;
import 'package:mockito/mockito.dart';

import '../../utils/make_app.dart';

class RandomDetailsBlocMock extends Mock implements RandomDetailsBloc {}

class FavoriteBlocMock extends Mock implements FavoriteBloc {}

class ShareQuoteMock extends Mock implements ShareQuote {}

void main() {
  RandomDetailsBlocMock randomDetailsBlocMock;
  FavoriteBlocMock favoriteBlocMock;
  ShareQuoteMock shareQuoteMock;

  setUp(() async {
    randomDetailsBlocMock = RandomDetailsBlocMock();
    favoriteBlocMock = FavoriteBlocMock();
    shareQuoteMock = ShareQuoteMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt
        .registerLazySingleton<RandomDetailsBloc>(() => randomDetailsBlocMock);
    sl.getIt.registerLazySingleton<FavoriteBloc>(() => favoriteBlocMock);
    sl.getIt.registerLazySingleton<ShareQuote>(() => shareQuoteMock);
  });

  tearDown(() async {
    randomDetailsBlocMock.close();
    favoriteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('renders screen', (tester) async {
    await tester.pumpWidget(makeApp(RandomDetailsScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("random_details_screen")), findsOneWidget);
  });

  testWidgets(
      'renders empty_widget widget when EmptyState is returned from bloc',
      (tester) async {
    when(randomDetailsBlocMock.state).thenAnswer((_) => EmptyState());

    await tester.pumpWidget(makeApp(RandomDetailsScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("emtpy_widget")), findsOneWidget);
  });

  testWidgets('renders loading when LoadingState is returned from bloc',
      (tester) async {
    when(randomDetailsBlocMock.state).thenAnswer((_) => LoadingState());

    await tester.pumpWidget(makeApp(RandomDetailsScreen()));
    await tester.pump();

    expect(find.byKey(Key("loading_widget")), findsOneWidget);
  });

  testWidgets(
      'renders success_widget widget when SuccessState is returned from bloc',
      (tester) async {
    when(randomDetailsBlocMock.state).thenAnswer(
      (_) => SuccessState(
        scrollPos: 1,
        quotes: [Quote(author: 'author', content: 'content', id: 1)],
      ),
    );
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(makeApp(RandomDetailsScreen()));
    await tester.pump();

    expect(find.byKey(Key("success_widget")), findsOneWidget);
  });

  testWidgets('renders load_error widget when ErrorState is returned from bloc',
      (tester) async {
    when(randomDetailsBlocMock.state).thenAnswer((_) => ErrorState());

    await tester.pumpWidget(makeApp(RandomDetailsScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_error_widget")), findsOneWidget);
  });
}
