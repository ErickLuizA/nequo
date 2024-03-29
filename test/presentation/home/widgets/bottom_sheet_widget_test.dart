import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/presentation/home/widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void getCategories() {}
}

class MethodsMock extends Mock implements Methods {}

class AddQuoteMock extends Mock implements AddQuote {}

class AddCategoryMock extends Mock implements AddCategory {}

void main() {
  final methodsMock = MethodsMock();
  final addQuoteMock = AddQuoteMock();
  final addCategoryMock = AddCategoryMock();

  setUp(() async {
    await sl.setUp(testing: true);
  });

  tearDown(() async {
    await sl.getIt.reset();
  });

  testWidgets('render widget', (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => BottomSheetWidget(
              getCategories: methodsMock.getCategories,
              scaffoldContext: context,
              list: [Category(id: 1, name: 'name')],
              addQuote: addQuoteMock,
              addCategory: addCategoryMock,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("bottom_sheet")), findsOneWidget);
  });

  testWidgets(
      'should render AddCategoryBottomSheet when open_add_quote_list button is tapped',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => BottomSheetWidget(
              getCategories: methodsMock.getCategories,
              scaffoldContext: context,
              list: [Category(id: 1, name: 'name')],
              addQuote: addQuoteMock,
              addCategory: addCategoryMock,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("open_add_quote_list_bottom_sheet")));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("add_quote_list_bottom_sheet")), findsOneWidget);
  });

  testWidgets(
      'should show Snackbar if list is empty when open_add_quote button is tapped',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => BottomSheetWidget(
              getCategories: methodsMock.getCategories,
              scaffoldContext: context,
              list: [],
              addQuote: addQuoteMock,
              addCategory: addCategoryMock,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("open_add_quote_bottom_sheet")));
    await tester.pump();

    expect(find.byKey(Key("empty_snackbar")), findsOneWidget);
  });

  testWidgets(
      'should render AddQuoteBottomSheet when open_add_quote button is tapped',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => BottomSheetWidget(
              getCategories: methodsMock.getCategories,
              scaffoldContext: context,
              list: [Category(id: 1, name: 'name')],
              addQuote: addQuoteMock,
              addCategory: addCategoryMock,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("open_add_quote_bottom_sheet")));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("add_quote_bottom_sheet")), findsOneWidget);
  });
}
