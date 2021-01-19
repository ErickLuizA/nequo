import 'package:NeQuo/presentation/random_details/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/make_app.dart';

void main() {
  testWidgets('render empty widget', (tester) async {
    await tester.pumpWidget(makeApp(Scaffold(body: EmptyWidget())));

    await tester.pumpAndSettle();

    expect(find.byKey(Key("empty_widget_safe_area")), findsOneWidget);
  });
}
