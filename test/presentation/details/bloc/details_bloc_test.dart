import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/presentation/details/bloc/details_bloc.dart';
import 'package:nequo/presentation/details/bloc/details_event.dart';
import 'package:nequo/presentation/details/bloc/details_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoadQuotes extends Mock implements LoadQuotes {}

void main() {
  DetailsBloc detailsBloc;
  MockLoadQuotes mockLoadQuotes;

  setUp(() {
    mockLoadQuotes = MockLoadQuotes();
    detailsBloc = DetailsBloc(
      loadQuotes: mockLoadQuotes,
    );
  });

  final loadQuotesParams = LoadQuotesParams(id: 1);

  final list = [Quote(content: 'dj', author: 'dj')];

  group('GetQuotes', () {
    test('should emit Loading and Success in order when use case returns Right',
        () async {
      when(mockLoadQuotes(any)).thenAnswer((_) async => Right(list));

      expect(
        detailsBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<SuccessState>(),
        ]),
      );

      detailsBloc.add(
        GetQuotes(
          params: loadQuotesParams,
        ),
      );
    });

    test(
        'should emit Loading and Empty in order when use case returns Right empty',
        () async {
      when(mockLoadQuotes(any)).thenAnswer((_) async => Right(List()));

      expect(
        detailsBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<EmptyState>(),
        ]),
      );

      detailsBloc.add(
        GetQuotes(
          params: loadQuotesParams,
        ),
      );
    });

    test('should emit Loading and Error in order when usecase returns left',
        () async {
      when(mockLoadQuotes(any)).thenAnswer((_) async => Left(CacheFailure()));

      expect(
        detailsBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<ErrorState>(),
        ]),
      );

      detailsBloc.add(
        GetQuotes(
          params: loadQuotesParams,
        ),
      );
    });
  });
}
