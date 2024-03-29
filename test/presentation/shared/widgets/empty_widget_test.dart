import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nequo/presentation/widgets/empty_list.dart';

import '../../../utils/make_app.dart';

void main() {
  testWidgets('render empty widget', (tester) async {
    await tester.pumpWidget(makeApp(Scaffold(body: EmptyList())));

    await tester.pumpAndSettle();

    expect(find.byKey(Key("empty_widget_safe_area")), findsOneWidget);
  });
}
