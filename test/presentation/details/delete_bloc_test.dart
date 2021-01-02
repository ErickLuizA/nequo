import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote_list.dart';
import 'package:NeQuo/presentation/details/bloc/delete_bloc.dart';
import 'package:NeQuo/presentation/details/bloc/delete_event.dart';
import 'package:NeQuo/presentation/details/bloc/delete_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDeleteQuote extends Mock implements DeleteQuote {}

class MockDeleteQuoteList extends Mock implements DeleteQuoteList {}

void main() {
  DeleteBloc deleteBloc;
  MockDeleteQuote mockDeleteQuote;
  MockDeleteQuoteList mockDeleteQuoteList;

  setUp(() {
    mockDeleteQuote = MockDeleteQuote();
    mockDeleteQuoteList = MockDeleteQuoteList();
    deleteBloc = DeleteBloc(
      deleteQuote: mockDeleteQuote,
      deleteQuoteList: mockDeleteQuoteList,
    );
  });

  final deleteQuoteParams = DeleteQuoteParams(id: 1);
  final deleteQuoteListParams = DeleteQuoteListParams(id: 1);

  group('DeleteQuoteEvent', () {
    test('should emit Loading and Success in order when use case returns Right',
        () async {
      when(mockDeleteQuote(any)).thenAnswer((_) async => Right(null));

      expect(
        deleteBloc,
        emitsInOrder([
          isA<DeleteLoadingState>(),
          isA<DeleteSuccessState>(),
        ]),
      );

      deleteBloc.add(
        DeleteQuoteEvent(
          params: deleteQuoteParams,
        ),
      );
    });

    test('should emit Loading and Error in order when usecase returns left',
        () async {
      when(mockDeleteQuote(any)).thenAnswer((_) async => Left(CacheFailure()));

      expect(
        deleteBloc,
        emitsInOrder([
          isA<DeleteLoadingState>(),
          isA<DeleteErrorState>(),
        ]),
      );

      deleteBloc.add(
        DeleteQuoteEvent(
          params: deleteQuoteParams,
        ),
      );
    });
  });

  group('DeleteQuoteListEvent', () {
    test('should emit Loading and Success in order when use case returns Right',
        () async {
      when(mockDeleteQuoteList(any)).thenAnswer((_) async => Right(null));

      expect(
        deleteBloc,
        emitsInOrder([
          isA<DeleteListLoadingState>(),
          isA<DeleteListSuccessState>(),
        ]),
      );

      deleteBloc.add(
        DeleteQuoteListEvent(
          params: deleteQuoteListParams,
        ),
      );
    });

    test('should emit Loading and Error in order when usecase returns left',
        () async {
      when(mockDeleteQuoteList(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      expect(
        deleteBloc,
        emitsInOrder([
          isA<DeleteListLoadingState>(),
          isA<DeleteListErrorState>(),
        ]),
      );

      deleteBloc.add(
        DeleteQuoteListEvent(
          params: deleteQuoteListParams,
        ),
      );
    });
  });
}
