import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/presentation/details/bloc/delete_bloc.dart';
import 'package:NeQuo/presentation/details/bloc/details_state.dart';
import 'package:NeQuo/presentation/details/widgets/success_widget.dart';
import 'package:NeQuo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:NeQuo/service_locator.dart' as sl;

import '../../../utils/make_app.dart';

class Methods {
  void getQuotesList() {}
  void handleDeleteQuoteList() {}
  void shareQuote(String text) {}
  void handleFavorite(Favorite fav, int index) {}
  void handleDeleteQuote(DeleteQuoteParams params) {}
  void getQuotes() {}
}

class MethodsMock extends Mock implements Methods {}

class FavoriteBlocMock extends Mock implements FavoriteBloc {}

class DeleteBlocMock extends Mock implements DeleteBloc {}

void main() {
  SuccessState state;
  MethodsMock methodsMock;
  FavoriteBlocMock favoriteBlocMock;
  DeleteBlocMock deleteBlocMock;

  setUp(() async {
    state = SuccessState(
      quotes: [Quote(author: 'author', content: 'content', id: 1)],
    );
    methodsMock = MethodsMock();
    favoriteBlocMock = FavoriteBlocMock();
    deleteBlocMock = DeleteBlocMock();

    await sl.setUp(testing: true);

    sl.getIt.allowReassignment = true;
    sl.getIt.registerLazySingleton<FavoriteBloc>(() => favoriteBlocMock);
    sl.getIt.registerLazySingleton<DeleteBloc>(() => deleteBlocMock);
  });

  tearDown(() async {
    favoriteBlocMock.close();
    deleteBlocMock.close();
    await sl.getIt.reset();
  });

  testWidgets('render SuccessWidget', (tester) async {
    when(favoriteBlocMock.state)
        .thenAnswer((_) => FavoriteSuccessState(favIndex: [1]));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl.getIt<FavoriteBloc>(),
              ),
              BlocProvider(
                create: (_) => sl.getIt<DeleteBloc>(),
              ),
            ],
            child: SuccessWidget(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
              successState: state,
              shareQuote: methodsMock.shareQuote,
              handleFavorite: methodsMock.handleFavorite,
              handleDeleteQuote: methodsMock.handleDeleteQuote,
              getQuotes: methodsMock.getQuotes,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byKey(Key("success_widget_column")), findsOneWidget);
  });

  testWidgets('should call share function when share_button is pressed',
      (tester) async {
    when(favoriteBlocMock.state)
        .thenAnswer((_) => FavoriteSuccessState(favIndex: [1]));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl.getIt<FavoriteBloc>(),
              ),
              BlocProvider(
                create: (_) => sl.getIt<DeleteBloc>(),
              ),
            ],
            child: SuccessWidget(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
              successState: state,
              shareQuote: methodsMock.shareQuote,
              handleFavorite: methodsMock.handleFavorite,
              handleDeleteQuote: methodsMock.handleDeleteQuote,
              getQuotes: methodsMock.getQuotes,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(Key("share_button")));

    verify(methodsMock.shareQuote(any)).called(1);
  });

  testWidgets('should render correct content and author', (tester) async {
    when(favoriteBlocMock.state)
        .thenAnswer((_) => FavoriteSuccessState(favIndex: [1]));
    await tester.pumpWidget(
      makeApp(
        Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl.getIt<FavoriteBloc>(),
              ),
              BlocProvider(
                create: (_) => sl.getIt<DeleteBloc>(),
              ),
            ],
            child: SuccessWidget(
              getQuotesList: methodsMock.getQuotesList,
              handleDeleteQuoteList: methodsMock.handleDeleteQuoteList,
              successState: state,
              shareQuote: methodsMock.shareQuote,
              handleFavorite: methodsMock.handleFavorite,
              handleDeleteQuote: methodsMock.handleDeleteQuote,
              getQuotes: methodsMock.getQuotes,
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('content'), findsOneWidget);
    expect(find.text('- author'), findsOneWidget);
  });
}
