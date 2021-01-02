import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/load_random_quote.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  LoadRandomQuote loadRandomQuote;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    loadRandomQuote = LoadRandomQuote(quoteRepository: mockQuoteRepository);
  });

  final randomQuote = Quote(
    author: 'author',
    content: 'content',
  );

  test('should get random quote from repository', () async {
    when(mockQuoteRepository.getRandom())
        .thenAnswer((_) async => Right(randomQuote));

    final result = await loadRandomQuote(NoParams());

    expect(result, Right(randomQuote));
  });

  test('should return error from repository', () async {
    when(mockQuoteRepository.getRandom())
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await loadRandomQuote(NoParams());

    expect(result, equals(Left(ServerFailure())));
  });
}
