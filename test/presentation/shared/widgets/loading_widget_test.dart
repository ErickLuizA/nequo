import 'package:NeQuo/presentation/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/make_app.dart';

void main() {
  testWidgets('render loading widget', (tester) async {
    await tester.pumpWidget(makeApp(Scaffold(body: LoadingWidget())));

    await tester.pump();

    expect(find.byKey(Key("loading_widget_center")), findsOneWidget);
  });
}
