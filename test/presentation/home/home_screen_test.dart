import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/presentation/home/bloc/home_list_bloc.dart';
import 'package:NeQuo/presentation/home/bloc/home_list_state.dart';
import 'package:NeQuo/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:NeQuo/service_locator.dart' as sl;
import 'package:mockito/mockito.dart';

import '../../utils/make_app.dart';

class HomeListBlocMock extends Mock implements HomeListBloc {}

void main() {
  HomeListBlocMock homeListBlocMock;

  setUp(() async {
    homeListBlocMock = HomeListBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<HomeListBloc>(() => homeListBlocMock);
  });

  tearDown(() async {
    homeListBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('renders screen', (tester) async {
    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("home_screen")), findsOneWidget);
  });

  testWidgets('renders loading when LoadingState is returned from bloc',
      (tester) async {
    when(homeListBlocMock.state).thenAnswer((_) => LoadingListState());

    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pump();

    expect(find.byKey(Key("loading")), findsOneWidget);
  });

  testWidgets('renders load_error widget when ErrorState is returned from bloc',
      (tester) async {
    when(homeListBlocMock.state).thenAnswer((_) => ErrorListState());

    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_error_widget")), findsOneWidget);
  });

  testWidgets(
      'renders success_list_state widget when SuccessState is returned from bloc',
      (tester) async {
    when(homeListBlocMock.state).thenAnswer(
      (_) => SuccessListState(quoteList: [QuoteList(id: 11, name: '22')]),
    );

    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("success_list_state")), findsOneWidget);
  });

  testWidgets(
      'renders empty list container when EmptyListState is returned from bloc',
      (tester) async {
    when(homeListBlocMock.state).thenAnswer((_) => EmptyListState());

    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("empty_list_state")), findsOneWidget);
  });

  testWidgets('renders bottomSheetWidget when fab is pressed', (tester) async {
    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("bottom_sheet_widget")), findsOneWidget);
  });
}
