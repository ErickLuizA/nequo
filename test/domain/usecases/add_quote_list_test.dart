import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/add_quote_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  AddQuoteList addQuoteList;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    addQuoteList = AddQuoteList(quoteListRepository: mockQuoteRepository);
  });

  final quoteListParams = QuoteList(
    name: 'name',
  );

  test('should call addQuoteList method in the repository with given params',
      () async {
    await addQuoteList(quoteListParams);

    verify(mockQuoteRepository.addQuoteList(quoteListParams));
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return CacheFailure when repository returns CacheFailure',
      () async {
    when(mockQuoteRepository.addQuoteList(quoteListParams))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await addQuoteList(quoteListParams);

    expect(result, equals(Left(CacheFailure())));
  });
}
