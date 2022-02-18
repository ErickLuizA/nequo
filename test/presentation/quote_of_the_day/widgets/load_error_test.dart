import 'package:nequo/presentation/screens/quote_of_the_day/widgets/load_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/make_app.dart';

class Methods {
  void navigate() {}
  void retry() {}
}

class MethodsMock extends Mock implements Methods {}

void main() {
  MethodsMock methodsMock = MethodsMock();

  testWidgets('render widget', (tester) async {
    await tester.pumpWidget(
      makeApp(
        LoadError(
          navigate: methodsMock.navigate,
          retry: methodsMock.retry,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_error_container")), findsOneWidget);
  });

  testWidgets('should call retry function when button is pressed',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        LoadError(
          navigate: methodsMock.navigate,
          retry: methodsMock.retry,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("try_again_button")));

    await tester.pump();

    verify(methodsMock.retry()).called(1);
  });

  testWidgets('should call navigate function when button is pressed',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        LoadError(
          navigate: methodsMock.navigate,
          retry: methodsMock.retry,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("continue_button")));

    await tester.pump();

    verify(methodsMock.navigate()).called(1);
  });
}
