import 'package:nequo/presentation/details/bloc/delete_bloc.dart';
import 'package:nequo/presentation/details/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void getQuotesList() {}
  void handleDeleteQuoteList() {}
}

class MethodsMock extends Mock implements Methods {}

class DeleteBlocMock extends Mock implements DeleteBloc {}

void main() {
  MethodsMock methodsMock;
  DeleteBlocMock deleteBlocMock;

  setUp(() async {
    methodsMock = MethodsMock();
    deleteBlocMock = DeleteBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<DeleteBloc>(() => deleteBlocMock);
  });

  tearDown(() async {
    deleteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('render EmptyWidget', (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<DeleteBloc>(),
            child: EmptyWidget(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("empty_widget_safe_area")), findsOneWidget);
  });
}
