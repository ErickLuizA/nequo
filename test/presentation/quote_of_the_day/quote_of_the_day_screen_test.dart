import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/presentation/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:NeQuo/presentation/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:NeQuo/presentation/quote_of_the_day/quote_of_the_day_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:NeQuo/service_locator.dart' as sl;
import 'package:mockito/mockito.dart';

import '../../utils/make_app.dart';

class QuoteOfTheDayBlocMock extends Mock implements QuoteOfTheDayBloc {}

void main() {
  final quoteOfTheDayBlocMock = QuoteOfTheDayBlocMock();

  setUp(() async {
    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt
        .registerLazySingleton<QuoteOfTheDayBloc>(() => quoteOfTheDayBlocMock);
  });

  tearDown(() async {
    quoteOfTheDayBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('renders screen', (tester) async {
    await tester.pumpWidget(makeApp(QuoteOfTheDayScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("quod_container")), findsOneWidget);
  });

  testWidgets('renders loading when LoadingState is returned from bloc',
      (tester) async {
    when(quoteOfTheDayBlocMock.state).thenAnswer((_) => LoadingState());

    await tester.pumpWidget(makeApp(QuoteOfTheDayScreen()));
    await tester.pump();

    expect(find.byKey(Key("loading")), findsOneWidget);
  });

  testWidgets(
      'renders load_success widget when SuccessState is returned from bloc',
      (tester) async {
    when(quoteOfTheDayBlocMock.state).thenAnswer(
      (_) => SuccessState(
        quote: Quote(author: 'eu', content: 'esse msm', id: 122),
      ),
    );

    await tester.pumpWidget(makeApp(QuoteOfTheDayScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_success")), findsOneWidget);
  });

  testWidgets('renders load_error widget when ErrorState is returned from bloc',
      (tester) async {
    when(quoteOfTheDayBlocMock.state).thenAnswer((_) => ErrorState());

    await tester.pumpWidget(makeApp(QuoteOfTheDayScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_error")), findsOneWidget);
  });
}
