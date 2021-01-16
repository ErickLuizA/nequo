import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/usecases/add_quote.dart';
import 'package:NeQuo/presentation/home/widgets/add_quote_bottom_sheet.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:NeQuo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void getQuotesList() {}
}

class MethodsMock extends Mock implements Methods {}

class AddQuoteMock extends Mock implements AddQuote {}

void main() {
  final methodsMock = MethodsMock();
  final addQuoteMock = AddQuoteMock();

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
            builder: (context) => AddQuoteBottomSheet(
              list: [QuoteList(id: 1, name: 'hello')],
              scaffoldContext: context,
              addQuote: addQuoteMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("add_quote_bottom_sheet_container")), findsOneWidget);
  });

  testWidgets('should not call addQuote if fields are not filled',
      (tester) async {
    when(addQuoteMock(any)).thenAnswer((_) async => Left(CacheFailure()));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddQuoteBottomSheet(
              list: [QuoteList(id: 1, name: 'hello')],
              scaffoldContext: context,
              addQuote: addQuoteMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    verifyNever(addQuoteMock(any));
  });

  testWidgets('should show snackbar if addQuote fails', (tester) async {
    when(addQuoteMock(any)).thenAnswer((_) async => Left(CacheFailure()));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddQuoteBottomSheet(
              list: [QuoteList(id: 1, name: 'hello')],
              scaffoldContext: context,
              addQuote: addQuoteMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("text_input_author")), 'author');
    await tester.enterText(find.byKey(Key("text_input_quote")), 'quote');

    await tester.tap(find.byKey(Key("dropdown")));

    await tester.pump();

    await tester.tap(find.text('hello').last);

    await tester.pump();

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    expect(find.byKey(Key("add_quote_snackbar")), findsOneWidget);
  });

  testWidgets('should call getQuotesList if addQuote succeds', (tester) async {
    when(addQuoteMock(any)).thenAnswer((_) async => Right(null));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddQuoteBottomSheet(
              list: [QuoteList(id: 1, name: 'hello')],
              scaffoldContext: context,
              addQuote: addQuoteMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("text_input_author")), 'author');
    await tester.enterText(find.byKey(Key("text_input_quote")), 'quote');

    await tester.tap(find.byKey(Key("dropdown")));

    await tester.pump();

    await tester.tap(find.text('hello').last);

    await tester.pump();

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    verify(methodsMock.getQuotesList()).called(1);
  });
}
