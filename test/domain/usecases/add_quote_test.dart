import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/add_quote.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  AddQuote addQuote;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    addQuote = AddQuote(quoteRepository: mockQuoteRepository);
  });

  final quoteParams = AddQuoteParams(
    content: 'content',
    author: 'author',
  );

  test('should call addQuote method in the repository with given params',
      () async {
    await addQuote(quoteParams);

    verify(mockQuoteRepository.addQuote(quoteParams));
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return a CacheFailure from repository', () async {
    when(mockQuoteRepository.addQuote(quoteParams))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await addQuote(quoteParams);

    expect(result, equals(Left(CacheFailure())));
  });
}
