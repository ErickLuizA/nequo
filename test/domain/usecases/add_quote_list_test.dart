import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  AddCategory addCategory;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    addCategory = AddCategory(quoteListRepository: mockQuoteRepository);
  });

  final quoteListParams = Category(
    name: 'name',
  );

  test('should call addCategory method in the repository with given params',
      () async {
    await addCategory(quoteListParams);

    verify(mockQuoteRepository.addCategory(quoteListParams));
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return CacheFailure when repository returns CacheFailure',
      () async {
    when(mockQuoteRepository.addCategory(quoteListParams))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await addCategory(quoteListParams);

    expect(result, equals(Left(CacheFailure())));
  });
}
