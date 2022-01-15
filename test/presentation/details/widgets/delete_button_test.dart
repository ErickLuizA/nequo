import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/presentation/details/bloc/delete_bloc.dart';
import 'package:nequo/presentation/details/bloc/delete_state.dart';
import 'package:nequo/presentation/details/bloc/details_state.dart';
import 'package:nequo/presentation/details/widgets/delete_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void handleDeleteQuote(DeleteQuoteParams params) {}
  void getQuotes() {}
}

class MethodsMock extends Mock implements Methods {}

class DeleteBlocMock extends Mock implements DeleteBloc {}

void main() {
  final methodsMock = MethodsMock();
  final state = SuccessState(
    quotes: [Quote(author: 'author', content: 'content', id: 1)],
  );
  final current = 0;
  DeleteBlocMock deleteBlocMock;

  setUp(() async {
    deleteBlocMock = DeleteBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<DeleteBloc>(() => deleteBlocMock);
  });

  tearDown(() async {
    deleteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('render DeleteButton', (tester) async {
    when(deleteBlocMock.state).thenAnswer(
      (_) => DeleteSuccessState(),
    );

    await tester.pumpWidget(
      makeApp(
        BlocProvider(
          create: (_) => sl.getIt<DeleteBloc>(),
          child: DeleteButton(
            current: current,
            handleDeleteQuote: methodsMock.handleDeleteQuote,
            successState: state,
            getQuotes: methodsMock.getQuotes,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("delete_button_bloc_builder")), findsOneWidget);
  });

  testWidgets(
      'should show delete loading when DeleteLoadingState is returned from bloc',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer(
      (_) => DeleteLoadingState(),
    );

    await tester.pumpWidget(
      makeApp(
        BlocProvider(
          create: (context) => sl.getIt<DeleteBloc>(),
          child: DeleteButton(
            current: current,
            handleDeleteQuote: methodsMock.handleDeleteQuote,
            successState: state,
            getQuotes: methodsMock.getQuotes,
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("delete_loading")), findsOneWidget);
  });

  testWidgets(
      'should show snackbar and button when DeleteErrorState is returned from bloc',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer(
      (_) => DeleteErrorState(),
    );

    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: BlocProvider(
            create: (context) => sl.getIt<DeleteBloc>(),
            child: DeleteButton(
              current: current,
              handleDeleteQuote: methodsMock.handleDeleteQuote,
              successState: state,
              getQuotes: methodsMock.getQuotes,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("error_delete_button")), findsOneWidget);

    await tester.pump();

    expect(find.byKey(Key("error_snackbar")), findsOneWidget);
  });

  testWidgets(
      'should call getQuotes function when DeleteSuccessState is returned from bloc',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer(
      (_) => DeleteSuccessState(),
    );

    await tester.pumpWidget(
      makeApp(
        BlocProvider(
          create: (_) => sl.getIt<DeleteBloc>(),
          child: DeleteButton(
            current: current,
            handleDeleteQuote: methodsMock.handleDeleteQuote,
            successState: state,
            getQuotes: methodsMock.getQuotes,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    verify(methodsMock.getQuotes()).called(2);
  });

  testWidgets('should call handleDeleteQuote function when button is pressed',
      (tester) async {
    when(deleteBlocMock.state).thenAnswer(
      (_) => DeleteInitialState(),
    );

    await tester.pumpWidget(
      makeApp(
        BlocProvider(
          create: (_) => sl.getIt<DeleteBloc>(),
          child: DeleteButton(
            current: current,
            handleDeleteQuote: methodsMock.handleDeleteQuote,
            successState: state,
            getQuotes: methodsMock.getQuotes,
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("delete_button")));

    verify(methodsMock.handleDeleteQuote(any)).called(1);
  });
}
