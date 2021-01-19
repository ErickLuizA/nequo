import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_state.dart';
import 'package:NeQuo/presentation/random_details/widgets/success_widget.dart';
import 'package:NeQuo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:NeQuo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void getRandomQuotes(int skip, int scrollPos) {}
  void handleFavorite(Favorite fav, int index) {}
}

class ShareQuoteMock extends Mock implements ShareQuote {}

class MethodsMock extends Mock implements Methods {}

class FavoriteBlocMock extends Mock implements FavoriteBloc {}

void main() {
  SuccessState state;
  ShareQuoteMock shareQuoteMock;
  MethodsMock methodsMock;
  FavoriteBlocMock favoriteBlocMock;

  setUp(() async {
    state = SuccessState(
        quotes: [Quote(author: 'author', content: 'content', id: 1)],
        scrollPos: 0);
    shareQuoteMock = ShareQuoteMock();
    methodsMock = MethodsMock();
    favoriteBlocMock = FavoriteBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<FavoriteBloc>(() => favoriteBlocMock);
  });

  tearDown(() async {
    favoriteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('render SuccessWidget', (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: SuccessWidget(
              getRandomQuotes: methodsMock.getRandomQuotes,
              handleFavorite: methodsMock.handleFavorite,
              share: shareQuoteMock,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("success_widget_column")), findsOneWidget);
  });

  testWidgets('should render correct content and author', (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: SuccessWidget(
              getRandomQuotes: methodsMock.getRandomQuotes,
              handleFavorite: methodsMock.handleFavorite,
              share: shareQuoteMock,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('content'), findsOneWidget);
    expect(find.text('- author'), findsOneWidget);
  });

  testWidgets('should call share function when share_button is pressed',
      (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: SuccessWidget(
              getRandomQuotes: methodsMock.getRandomQuotes,
              handleFavorite: methodsMock.handleFavorite,
              share: shareQuoteMock,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("share_button")));

    verify(shareQuoteMock(any)).called(1);
  });

  testWidgets('should call favorite function when favorite_button is pressed',
      (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: SuccessWidget(
              getRandomQuotes: methodsMock.getRandomQuotes,
              handleFavorite: methodsMock.handleFavorite,
              share: shareQuoteMock,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("favorite_button")));

    verify(methodsMock.handleFavorite(any, any)).called(1);
  });

  testWidgets(
      'should call getRandomQuotes function when current quote is the last in the list',
      (tester) async {
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<FavoriteBloc>(),
            child: SuccessWidget(
              getRandomQuotes: methodsMock.getRandomQuotes,
              handleFavorite: methodsMock.handleFavorite,
              share: shareQuoteMock,
              state: state,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    verify(methodsMock.getRandomQuotes(any, any)).called(1);
  });
}
