import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/load_quotes_list.dart';
import 'package:nequo/presentation/home/bloc/home_list_bloc.dart';
import 'package:nequo/presentation/home/bloc/home_list_event.dart';
import 'package:nequo/presentation/home/bloc/home_list_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoadQuotesList extends Mock implements LoadQuotesList {}

void main() {
  HomeListBloc homeListBloc;
  MockLoadQuotesList mockLoadQuotesList;

  setUp(() {
    mockLoadQuotesList = MockLoadQuotesList();
    homeListBloc = HomeListBloc(
      loadQuotesList: mockLoadQuotesList,
    );
  });

  group('GetQuotesList', () {
    test('should get data from LoadQuotesList usecase', () async {
      when(mockLoadQuotesList(any))
          .thenAnswer((_) async => Right(List<QuoteList>()));

      homeListBloc.add(
        GetQuotesList(),
      );

      await untilCalled(mockLoadQuotesList(any));

      verify(mockLoadQuotesList(any));
    });

    test(
        'should emit Loading and Empty in order when data gotten successfully but is Empty',
        () async {
      when(mockLoadQuotesList(any))
          .thenAnswer((_) async => Right(List<QuoteList>()));

      expect(
        homeListBloc,
        emitsInOrder([
          isA<LoadingListState>(),
          isA<EmptyListState>(),
        ]),
      );

      homeListBloc.add(
        GetQuotesList(),
      );
    });

    test(
        'should emit Loading and Success in order when data gotten successfully',
        () async {
      when(mockLoadQuotesList(any))
          .thenAnswer((_) async => Right([QuoteList(name: 'name')]));

      expect(
        homeListBloc,
        emitsInOrder([
          isA<LoadingListState>(),
          isA<SuccessListState>(),
        ]),
      );

      homeListBloc.add(
        GetQuotesList(),
      );
    });

    test('should emit Loading and Error in order when getting data fails',
        () async {
      when(mockLoadQuotesList(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      expect(
        homeListBloc,
        emitsInOrder([
          isA<LoadingListState>(),
          isA<ErrorListState>(),
        ]),
      );

      homeListBloc.add(
        GetQuotesList(),
      );
    });
  });
}
