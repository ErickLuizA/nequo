import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/delete_quote_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  DeleteQuoteList deleteQuoteList;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    deleteQuoteList = DeleteQuoteList(quoteRepository: mockQuoteRepository);
  });

  final params = DeleteQuoteListParams(id: 1);

  test('should call QuoteListRepository.deleteQuoteList with given params',
      () async {
    await deleteQuoteList(params);

    verify(mockQuoteRepository.deleteQuoteList(params));
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return a Failure from repository', () async {
    when(mockQuoteRepository.deleteQuoteList(params))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await deleteQuoteList(params);

    expect(result, equals(Left(CacheFailure())));
  });
}
