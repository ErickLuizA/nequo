import 'package:nequo/presentation/widgets/load_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/make_app.dart';

class Methods {
  void retry() {}
}

class MethodsMock extends Mock implements Methods {}

void main() {
  final methodsMock = MethodsMock();
  testWidgets('render load error widget', (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: LoadErrorWidget(
            retry: methodsMock.retry,
            text: 'Hello',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_error_widget_column")), findsOneWidget);
  });

  testWidgets('should find given text', (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: LoadErrorWidget(
            retry: methodsMock.retry,
            text: 'Hello',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('should call retry function when button is pressed',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: LoadErrorWidget(
            retry: methodsMock.retry,
            text: 'Hello',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("try_again_button")));

    verify(methodsMock.retry()).called(1);
  });
}
