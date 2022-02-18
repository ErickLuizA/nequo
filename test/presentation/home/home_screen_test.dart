import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/presentation/home/bloc/home_list_bloc.dart';
import 'package:nequo/presentation/home/bloc/home_list_state.dart';
import 'package:nequo/presentation/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nequo/service_locator.dart' as sl;
import 'package:mockito/mockito.dart';

import '../../utils/make_app.dart';

class HomeBlocMock extends Mock implements HomeBloc {}

void main() {
  HomeBlocMock homeBlocMock;

  setUp(() async {
    homeBlocMock = HomeBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<HomeBloc>(() => homeBlocMock);
  });

  tearDown(() async {
    homeBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('renders screen', (tester) async {
    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("home_screen")), findsOneWidget);
  });

  testWidgets('renders loading when LoadingState is returned from bloc',
      (tester) async {
    when(homeBlocMock.state).thenAnswer((_) => LoadingListState());

    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pump();

    expect(find.byKey(Key("loading")), findsOneWidget);
  });

  testWidgets('renders load_error widget when ErrorState is returned from bloc',
      (tester) async {
    when(homeBlocMock.state).thenAnswer((_) => ErrorListState());

    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("load_error_widget")), findsOneWidget);
  });

  testWidgets(
      'renders success_list_state widget when SuccessState is returned from bloc',
      (tester) async {
    when(homeBlocMock.state).thenAnswer(
      (_) => SuccessListState(quoteList: [Category(id: 11, name: '22')]),
    );

    await tester.pumpWidget(makeApp(HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(Key("success_list_state")), findsOneWidget);
  });

  testWidgets(
      'renders empty list container when EmptyListState is returned from bloc',
      (tester) async {
    when(homeBlocMock.state).thenAnswer((_) => EmptyListState());

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
