import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/load_random_quote.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoadRandomQuote extends Mock implements LoadRandomQuote {}

void main() {
  QuoteOfTheDayBloc quoteOfTheDayBloc;
  MockLoadRandomQuote mockLoadRandomQuote;

  setUp(() {
    mockLoadRandomQuote = MockLoadRandomQuote();
    quoteOfTheDayBloc = QuoteOfTheDayBloc(
      loadRandomQuote: mockLoadRandomQuote,
    );
  });

  final randomQuote = Quote(
    author: 'author',
    content: 'content',
  );

  group('GetRandomQuote', () {
    test(
        'should emit Loading and Success in order when data gotten successfully',
        () async {
      when(mockLoadRandomQuote(any))
          .thenAnswer((_) async => Right(randomQuote));

      expect(
        quoteOfTheDayBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<SuccessState>(),
        ]),
      );

      quoteOfTheDayBloc.add(GetRandomQuote());
    });

    test('should emit Loading and Error in order when getting data fails',
        () async {
      when(mockLoadRandomQuote(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      expect(
        quoteOfTheDayBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<ErrorState>(),
        ]),
      );

      quoteOfTheDayBloc.add(GetRandomQuote());
    });
  });
}
