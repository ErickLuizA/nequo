import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  DeleteQuote deleteQuote;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    deleteQuote = DeleteQuote(quoteRepository: mockQuoteRepository);
  });

  final params = DeleteQuoteParams(id: 1);

  test('should call QuoteRepository.deleteQuote with given params', () async {
    await deleteQuote(params);

    verify(mockQuoteRepository.deleteQuote(params));
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return a Failure from repository', () async {
    when(mockQuoteRepository.deleteQuote(params))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await deleteQuote(params);

    expect(result, equals(Left(CacheFailure())));
  });
}
