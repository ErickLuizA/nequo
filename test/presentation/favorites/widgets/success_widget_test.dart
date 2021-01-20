import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_state.dart';
import 'package:NeQuo/presentation/favorites/widgets/success_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:NeQuo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void shareQuote(String text) {}
  void deleteFavorite(int id) {}
}

class MethodsMock extends Mock implements Methods {}

void main() {
  MethodsMock methodsMock;
  SuccessState state;

  setUp(() async {
    methodsMock = MethodsMock();
    state = SuccessState(
        favorites: [Favorite(author: 'author', content: 'content', id: 1)]);

    await sl.setUp(testing: true);
  });

  tearDown(() async {
    await sl.getIt.reset();
  });

  testWidgets('render widget', (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: SuccessWidget(
            deleteFavorite: methodsMock.deleteFavorite,
            shareQuote: methodsMock.shareQuote,
            state: state,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("success_widget_column")), findsOneWidget);
  });

  testWidgets('should call shareQuote function when button is pressed',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: SuccessWidget(
            deleteFavorite: methodsMock.deleteFavorite,
            shareQuote: methodsMock.shareQuote,
            state: state,
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("share_action_button")));

    await tester.pump();

    verify(methodsMock.shareQuote(any)).called(1);
  });

  testWidgets('should call deleteFavorite function when button is pressed',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: SuccessWidget(
            deleteFavorite: methodsMock.deleteFavorite,
            shareQuote: methodsMock.shareQuote,
            state: state,
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("delete_action_button")));

    await tester.pump();

    verify(methodsMock.deleteFavorite(any)).called(1);
  });

  testWidgets('should display the quote content and author passed in the state',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: SuccessWidget(
            deleteFavorite: methodsMock.deleteFavorite,
            shareQuote: methodsMock.shareQuote,
            state: state,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text("- ${state.favorites[0].author}"), findsOneWidget);
    expect(find.text(state.favorites[0].content), findsOneWidget);
  });
}
