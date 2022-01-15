import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/add_quote_list.dart';
import 'package:nequo/presentation/home/widgets/bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void getQuotesList() {}
}

class MethodsMock extends Mock implements Methods {}

class AddQuoteMock extends Mock implements AddQuote {}

class AddQuoteListMock extends Mock implements AddQuoteList {}

void main() {
  final methodsMock = MethodsMock();
  final addQuoteMock = AddQuoteMock();
  final addQuoteListMock = AddQuoteListMock();

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
              getQuotesList: methodsMock.getQuotesList,
              scaffoldContext: context,
              list: [QuoteList(id: 1, name: 'name')],
              addQuote: addQuoteMock,
              addQuoteList: addQuoteListMock,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("bottom_sheet")), findsOneWidget);
  });

  testWidgets(
      'should render AddQuoteListBottomSheet when open_add_quote_list button is tapped',
      (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => BottomSheetWidget(
              getQuotesList: methodsMock.getQuotesList,
              scaffoldContext: context,
              list: [QuoteList(id: 1, name: 'name')],
              addQuote: addQuoteMock,
              addQuoteList: addQuoteListMock,
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
              getQuotesList: methodsMock.getQuotesList,
              scaffoldContext: context,
              list: [],
              addQuote: addQuoteMock,
              addQuoteList: addQuoteListMock,
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
              getQuotesList: methodsMock.getQuotesList,
              scaffoldContext: context,
              list: [QuoteList(id: 1, name: 'name')],
              addQuote: addQuoteMock,
              addQuoteList: addQuoteListMock,
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
