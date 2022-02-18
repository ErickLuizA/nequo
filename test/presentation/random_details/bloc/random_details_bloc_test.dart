import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_bloc.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_event.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoadRandomQuotes extends Mock implements LoadRandomQuotes {}

void main() {
  RandomDetailsBloc randomDetailsBloc;
  MockLoadRandomQuotes mockLoadRandomQuotes;

  setUp(() {
    mockLoadRandomQuotes = MockLoadRandomQuotes();
    randomDetailsBloc = RandomDetailsBloc(
      loadRandomQuotes: mockLoadRandomQuotes,
    );
  });

  final loadRandomQuotesParams = LoadRandomQuotesParams(skip: 1);

  final list = [Quote(content: 'dj', author: 'dj')];

  group('GetQuotes', () {
    test('should emit Loading and Success in order when use case returns Right',
        () async {
      when(mockLoadRandomQuotes(any)).thenAnswer((_) async => Right(list));

      expect(
        randomDetailsBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<SuccessState>(),
        ]),
      );

      randomDetailsBloc.add(
        GetRandomQuotes(
          params: loadRandomQuotesParams,
        ),
      );
    });

    test('should emit Loading and Error in order when usecase returns left',
        () async {
      when(mockLoadRandomQuotes(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      expect(
        randomDetailsBloc,
        emitsInOrder([
          isA<LoadingState>(),
          isA<ErrorState>(),
        ]),
      );

      randomDetailsBloc.add(
        GetRandomQuotes(
          params: loadRandomQuotesParams,
        ),
      );
    });
  });
}
