import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nequo/presentation/widgets/loading_indicator.dart';

import '../../../utils/make_app.dart';

void main() {
  testWidgets('render loading widget', (tester) async {
    await tester.pumpWidget(makeApp(Scaffold(body: LoadingIndicator())));

    await tester.pump();

    expect(find.byKey(Key("loading_widget_center")), findsOneWidget);
  });
}
