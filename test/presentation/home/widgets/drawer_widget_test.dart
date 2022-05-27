import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/presentation/home/widgets/drawer_widget.dart';

import '../../../utils/make_app.dart';

class Methods {
  void handleNavigateToFavorites() {}
  void handleShare() {}
}

class MethodsMock extends Mock implements Methods {}

void main() {
  final methodsMock = MethodsMock();

  testWidgets('render widget', (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Drawer(
            handleNavigateToFavorites: methodsMock.handleNavigateToFavorites,
            handleShare: methodsMock.handleShare,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(Key("drawer")), findsOneWidget);
  });

  testWidgets(
      'should call handleNavigateToFavorites function where ListTile navigation is tapped',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Drawer(
            handleNavigateToFavorites: methodsMock.handleNavigateToFavorites,
            handleShare: methodsMock.handleShare,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("list_tile_navigation")));
    await tester.pump();

    verify(methodsMock.handleNavigateToFavorites()).called(1);
  });

  testWidgets('should call share function when share ListTile is tapped',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Drawer(
            handleNavigateToFavorites: methodsMock.handleNavigateToFavorites,
            handleShare: methodsMock.handleShare,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("list_tile_share")));
    await tester.pump();

    verify(methodsMock.handleShare()).called(1);
  });
}
