import 'package:nequo/presentation/details/bloc/delete_bloc.dart';
import 'package:nequo/presentation/details/bloc/delete_state.dart';
import 'package:nequo/presentation/details/widgets/options_menu.dart';
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

  testWidgets('render OptionsMenu', (tester) async {
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<DeleteBloc>(),
            child: OptionsMenu(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("options_menu_bloc_builder")), findsOneWidget);
  });

  testWidgets(
      'should render LoadingWidget when DeleteListLoadingState is returned from bloc',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer((_) => DeleteListLoadingState());

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<DeleteBloc>(),
            child: OptionsMenu(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("delete_list_loading")), findsOneWidget);
  });

  testWidgets(
      'should render PopupMenuButton and snackbar when DeleteListErrorState is returned from bloc',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer((_) => DeleteListErrorState());

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<DeleteBloc>(),
            child: OptionsMenu(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("delete_popup_menu_button")), findsOneWidget);

    await tester.pump();

    expect(find.byKey(Key("delete_list_snackbar")), findsOneWidget);
  });

  testWidgets(
      'should call getQuotesList when DeleteListSuccessState is returned from bloc',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer((_) => DeleteListSuccessState());

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<DeleteBloc>(),
            child: OptionsMenu(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    verify(methodsMock.getQuotesList()).called(1);
  });

  testWidgets(
      'should call handleDeleteQuoteList when PopupMenuButton is pressed',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer((_) => DeleteInitialState());

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<DeleteBloc>(),
            child: OptionsMenu(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("popup_menu_button")));

    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuItem));

    verify(methodsMock.handleDeleteQuoteList()).called(1);
  });
}
