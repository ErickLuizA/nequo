import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/delete_category.dart';
import 'package:nequo/presentation/details/bloc/delete_bloc.dart';
import 'package:nequo/presentation/details/bloc/delete_event.dart';
import 'package:nequo/presentation/details/bloc/delete_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDeleteQuote extends Mock implements DeleteQuote {}

class MockDeleteCategory extends Mock implements DeleteCategory {}

void main() {
  DeleteBloc deleteBloc;
  MockDeleteQuote mockDeleteQuote;
  MockDeleteCategory mockDeleteCategory;

  setUp(() {
    mockDeleteQuote = MockDeleteQuote();
    mockDeleteCategory = MockDeleteCategory();
    deleteBloc = DeleteBloc(
      deleteQuote: mockDeleteQuote,
      deleteCategory: mockDeleteCategory,
    );
  });

  final deleteQuoteParams = DeleteQuoteParams(id: 1);
  final deleteCategoryParams = DeleteCategoryParams(id: 1);

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

  group('DeleteCategoryEvent', () {
    test('should emit Loading and Success in order when use case returns Right',
        () async {
      when(mockDeleteCategory(any)).thenAnswer((_) async => Right(null));

      expect(
        deleteBloc,
        emitsInOrder([
          isA<DeleteListLoadingState>(),
          isA<DeleteListSuccessState>(),
        ]),
      );

      deleteBloc.add(
        DeleteCategoryEvent(
          params: deleteCategoryParams,
        ),
      );
    });

    test('should emit Loading and Error in order when usecase returns left',
        () async {
      when(mockDeleteCategory(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      expect(
        deleteBloc,
        emitsInOrder([
          isA<DeleteListLoadingState>(),
          isA<DeleteListErrorState>(),
        ]),
      );

      deleteBloc.add(
        DeleteCategoryEvent(
          params: deleteCategoryParams,
        ),
      );
    });
  });
}
