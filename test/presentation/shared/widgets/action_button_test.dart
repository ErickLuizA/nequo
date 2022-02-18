import 'package:nequo/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/make_app.dart';

class Methods {
  void onPress() {}
}

class MethodsMock extends Mock implements Methods {}

void main() {
  final methodsMock = MethodsMock();

  testWidgets('render ActionButton', (tester) async {
    await tester.pumpWidget(
      makeApp(
        ActionButton(
          icon: Icons.add,
          onPress: methodsMock.onPress,
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("action_button_align")), findsOneWidget);
  });

  testWidgets('should call onPress function when icon_button is pressed',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        ActionButton(
          icon: Icons.add,
          onPress: methodsMock.onPress,
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("icon_button")));

    verify(methodsMock.onPress()).called(1);
  });
}
