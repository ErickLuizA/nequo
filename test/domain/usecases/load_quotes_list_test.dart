import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/load_quotes_list.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  LoadQuotesList loadQuotesList;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    loadQuotesList = LoadQuotesList(quoteRepository: mockQuoteRepository);
  });

  test('should call quoteRepository.getQuotesList with given params', () async {
    await loadQuotesList(NoParams());

    verify(mockQuoteRepository.getQuotesList());
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return a List<Quote> from repository', () async {
    when(mockQuoteRepository.getQuotesList())
        .thenAnswer((_) async => Right(List<QuoteList>()));

    final result = await loadQuotesList(NoParams());

    expect(result, isA<Right<Failure, List<QuoteList>>>());
  });

  test('should return a Failure from repository', () async {
    when(mockQuoteRepository.getQuotesList())
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await loadQuotesList(NoParams());

    expect(result, equals(Left(CacheFailure())));
  });
}
