import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/load_quote.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  LoadQuotes loadQuotes;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    loadQuotes = LoadQuotes(quoteRepository: mockQuoteRepository);
  });

  final quoteParams = LoadQuotesParams(
    id: 0,
  );

  test('should call quoteRepository.getQuotes with given params', () async {
    await loadQuotes(quoteParams);

    verify(mockQuoteRepository.getQuotes(quoteParams));
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return a List<Quote> from repository', () async {
    when(mockQuoteRepository.getQuotes(quoteParams))
        .thenAnswer((_) async => Right(List<Quote>()));

    final result = await loadQuotes(quoteParams);

    expect(result, isA<Right<Failure, List<Quote>>>());
  });

  test('should return a Failure from repository', () async {
    when(mockQuoteRepository.getQuotes(quoteParams))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await loadQuotes(quoteParams);

    expect(result, equals(Left(CacheFailure())));
  });
}
