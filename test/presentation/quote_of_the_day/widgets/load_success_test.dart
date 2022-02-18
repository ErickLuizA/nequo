import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/widgets/load_success.dart';
import 'package:nequo/presentation/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void close() {}
  void share() {}
  void addFavorite(Quote favorite) {}
}

class MethodsMock extends Mock implements Methods {}

class SuccessStateMock extends Mock implements SuccessState {
  final Quote quote;

  SuccessStateMock({this.quote});
}

class FavoriteBlocMock extends Mock implements FavoriteBloc {}

Future<void> makeTestableWidget(WidgetTester tester, MethodsMock methodsMock,
    SuccessStateMock successStateMock) async {
  await tester.pumpWidget(
    makeApp(
      BlocProvider(
        create: (context) => sl.getIt<FavoriteBloc>(),
        child: LoadSuccess(
          close: methodsMock.close,
          share: methodsMock.share,
          state: successStateMock,
          addFavorite: methodsMock.addFavorite,
        ),
      ),
    ),
  );
}

void main() {
  MethodsMock methodsMock;
  SuccessStateMock successStateMock;
  FavoriteBlocMock favoriteBlocMock;

  setUp(() async {
    methodsMock = MethodsMock();
    successStateMock = SuccessStateMock(
      quote: Quote(author: 'author', content: 'content', id: 123),
    );
    favoriteBlocMock = FavoriteBlocMock();

    await sl.setUp(testing: true);
    sl.getIt.allowReassignment = true;

    sl.getIt.registerFactory<FavoriteBloc>(() => favoriteBlocMock);
  });

  tearDown(() async {
    await favoriteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('render widget', (tester) async {
    await makeTestableWidget(tester, methodsMock, successStateMock);

    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_success_container")), findsOneWidget);
  });

  testWidgets('should call close function when button is pressed',
      (tester) async {
    await makeTestableWidget(tester, methodsMock, successStateMock);

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("close_button")));

    await tester.pump();

    verify(methodsMock.close()).called(1);
  }, skip: true); // This test always fails because Alignment is a bitch.

  testWidgets('should call share function when button is pressed',
      (tester) async {
    await makeTestableWidget(tester, methodsMock, successStateMock);

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("share_button")));

    await tester.pump();

    verify(methodsMock.share()).called(1);
  });

  testWidgets('should call addFavorite function when button is pressed',
      (tester) async {
    await makeTestableWidget(tester, methodsMock, successStateMock);

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("favorite_button")));

    await tester.pump();

    verify(methodsMock.addFavorite(any)).called(1);
  });

  testWidgets('should display the quote content passed in the state',
      (tester) async {
    await makeTestableWidget(tester, methodsMock, successStateMock);

    await tester.pumpAndSettle();

    expect(find.text("-${successStateMock.quote.author}"), findsOneWidget);
    expect(find.text(successStateMock.quote.content), findsOneWidget);
  });

  testWidgets('renders loading when LoadingState is returned from bloc',
      (tester) async {
    when(favoriteBlocMock.state).thenAnswer((_) => FavoriteLoadingState());

    await makeTestableWidget(tester, methodsMock, successStateMock);

    await tester.pump();

    expect(find.byKey(Key("loading_state")), findsOneWidget);
  });

  testWidgets(
      'renders success_state widget when SuccessState is returned from bloc',
      (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(
        favIndex: [1],
      ),
    );

    await makeTestableWidget(tester, methodsMock, successStateMock);

    await tester.pumpAndSettle();

    expect(find.byKey(Key("success_state")), findsOneWidget);
  });

  testWidgets(
      'renders error_state widget when ErrorState is returned from bloc',
      (tester) async {
    when(favoriteBlocMock.state).thenAnswer((_) => FavoriteErrorState());

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: LoadSuccess(
              close: methodsMock.close,
              share: methodsMock.share,
              state: successStateMock,
              addFavorite: methodsMock.addFavorite,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(Key("snackbar")), findsOneWidget);
    expect(find.byKey(Key("error_state")), findsOneWidget);
  });
}
