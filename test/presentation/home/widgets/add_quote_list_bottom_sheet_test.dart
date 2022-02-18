import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/presentation/home/widgets/add_quote_list_bottom_sheet.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void getCategories() {}
}

class MethodsMock extends Mock implements Methods {}

class AddCategoryMock extends Mock implements AddCategory {}

void main() {
  final methodsMock = MethodsMock();
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
            builder: (context) => AddCategoryBottomSheet(
              scaffoldContext: context,
              addCategory: addCategoryMock,
              getCategories: methodsMock.getCategories,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("add_quote_list_bottom_sheet_container")),
        findsOneWidget);
  });

  testWidgets('should not call addCategory if a name is not given',
      (tester) async {
    when(addCategoryMock(any)).thenAnswer((_) async => Left(CacheFailure()));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddCategoryBottomSheet(
              scaffoldContext: context,
              addCategory: addCategoryMock,
              getCategories: methodsMock.getCategories,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    verifyNever(addCategoryMock(any));
  });

  testWidgets('should show snackbar if addQuiteList fails', (tester) async {
    when(addCategoryMock(any)).thenAnswer((_) async => Left(CacheFailure()));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddCategoryBottomSheet(
              scaffoldContext: context,
              addCategory: addCategoryMock,
              getCategories: methodsMock.getCategories,
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

  testWidgets('should call getCategories if addCategory succeds',
      (tester) async {
    when(addCategoryMock(any)).thenAnswer((_) async => Right(null));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: Builder(
            builder: (context) => AddCategoryBottomSheet(
              scaffoldContext: context,
              addCategory: addCategoryMock,
              getCategories: methodsMock.getCategories,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key("text_input")), 'name');

    await tester.tap(find.byKey(Key("create_button")));

    await tester.pump();

    verify(methodsMock.getCategories()).called(1);
  });
}
