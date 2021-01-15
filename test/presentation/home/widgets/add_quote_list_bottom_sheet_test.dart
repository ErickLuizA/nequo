import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/usecases/add_quote_list.dart';
import 'package:NeQuo/presentation/home/widgets/add_quote_list_bottom_sheet.dart';
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

class AddQuoteListMock extends Mock implements AddQuoteList {}

void main() {
  final methodsMock = MethodsMock();
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
            builder: (context) => AddQuoteListBottomSheet(
              scaffoldContext: context,
              addQuoteList: addQuoteListMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("add_quote_list_bottom_sheet_container")),
        findsOneWidget);
  });

  testWidgets('should not call addQuoteList if a name is not given',
      (tester) async {
    when(addQuoteListMock(any)).thenAnswer((_) async => Left(CacheFailure()));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddQuoteListBottomSheet(
              scaffoldContext: context,
              addQuoteList: addQuoteListMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    verifyNever(addQuoteListMock(any));
  });

  testWidgets('should show snackbar if addQuiteList fails', (tester) async {
    when(addQuoteListMock(any)).thenAnswer((_) async => Left(CacheFailure()));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddQuoteListBottomSheet(
              scaffoldContext: context,
              addQuoteList: addQuoteListMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("text_input")), 'name');

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    expect(find.byKey(Key("add_quote_list_snackbar")), findsOneWidget);
  });

  testWidgets('should call getQuotesList if addQuoteList succeds',
      (tester) async {
    when(addQuoteListMock(any)).thenAnswer((_) async => Right(null));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddQuoteListBottomSheet(
              scaffoldContext: context,
              addQuoteList: addQuoteListMock,
              getQuotesList: methodsMock.getQuotesList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("text_input")), 'name');

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    verify(methodsMock.getQuotesList()).called(1);
  });
}
