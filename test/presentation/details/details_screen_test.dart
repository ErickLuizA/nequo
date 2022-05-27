import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/bloc/favorite_bloc.dart';
import 'package:nequo/presentation/details/bloc/details_bloc.dart';
import 'package:nequo/presentation/details/bloc/details_state.dart';
import 'package:nequo/presentation/details/details_screen.dart';
import 'package:nequo/service_locator.dart' as sl;

import '../../utils/make_app.dart';

class Methods {
  void getCategories() {}
}

class MethodsMock extends Mock implements Methods {}

class FavoriteBlocMock extends Mock implements FavoriteBloc {}

class DetailsBlocMock extends Mock implements DetailsBloc {}

void main() {
  MethodsMock methodsMock;
  FavoriteBlocMock favoriteBlocMock;
  DetailsBlocMock detailsBlocMock;
  Category quoteList;

  setUp(() async {
    methodsMock = MethodsMock();
    favoriteBlocMock = FavoriteBlocMock();
    detailsBlocMock = DetailsBlocMock();
    quoteList = Category(id: 1, name: 'name');

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<FavoriteBloc>(() => favoriteBlocMock);
    sl.getIt.registerLazySingleton<DetailsBloc>(() => detailsBlocMock);
  });

  tearDown(() async {
    favoriteBlocMock.close();
    detailsBlocMock.close();
    await sl.getIt.reset();
  });
  testWidgets('render details screen', (tester) async {
    await tester.pumpWidget(
      makeApp(
        DetailsScreen(
          getCategories: methodsMock.getCategories,
          quoteList: quoteList,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("details_screen")), findsOneWidget);
  });

  testWidgets('should show EmptyList when EmptyState is returned from bloc',
      (tester) async {
    when(detailsBlocMock.state).thenAnswer((_) => EmptyState());

    await tester.pumpWidget(
      makeApp(
        DetailsScreen(
          getCategories: methodsMock.getCategories,
          quoteList: quoteList,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(Key("empty_widget")), findsOneWidget);
  });

  testWidgets(
      'should show LoadingIndicator when LoadingState is returned from bloc',
      (tester) async {
    when(detailsBlocMock.state).thenAnswer((_) => LoadingState());

    await tester.pumpWidget(
      makeApp(
        DetailsScreen(
          getCategories: methodsMock.getCategories,
          quoteList: quoteList,
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("loading_widget")), findsOneWidget);
  });

  testWidgets(
      'should show SuccessWidget when SuccessState is returned from bloc',
      (tester) async {
    when(detailsBlocMock.state).thenAnswer((_) => SuccessState(
        quotes: [Quote(author: 'author', content: 'content', id: 1)]));
    when(favoriteBlocMock.state).thenAnswer(
      (_) => FavoriteSuccessState(favIndex: [1]),
    );

    await tester.pumpWidget(
      makeApp(
        DetailsScreen(
          getCategories: methodsMock.getCategories,
          quoteList: quoteList,
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("success_widget")), findsOneWidget);
  });

  testWidgets('should show ErrorHandler when ErrorState is returned from bloc',
      (tester) async {
    when(detailsBlocMock.state).thenAnswer((_) => ErrorState());

    await tester.pumpWidget(
      makeApp(
        DetailsScreen(
          getCategories: methodsMock.getCategories,
          quoteList: quoteList,
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("load_error_widget")), findsOneWidget);
  });
}
