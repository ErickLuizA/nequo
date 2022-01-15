import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  LoadRandomQuotes loadRandomQuotes;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    loadRandomQuotes = LoadRandomQuotes(quoteRepository: mockQuoteRepository);
  });

  final params = LoadRandomQuotesParams(skip: 0);

  test('should get List<Quote>> from repository', () async {
    when(mockQuoteRepository.getRandomQuotes(params))
        .thenAnswer((_) async => Right(List<Quote>()));

    final result = await loadRandomQuotes(params);

    expect(result, isA<Right<Failure, List<Quote>>>());
  });

  test('should return error from repository', () async {
    when(mockQuoteRepository.getRandomQuotes(params))
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await loadRandomQuotes(params);

    expect(result, equals(Left(ServerFailure())));
  });
}
