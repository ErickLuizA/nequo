import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/delete_category.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  DeleteCategory deleteCategory;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    deleteCategory = DeleteCategory(quoteRepository: mockQuoteRepository);
  });

  final params = DeleteCategoryParams(id: 1);

  test('should call CategoryRepository.deleteCategory with given params',
      () async {
    await deleteCategory(params);

    verify(mockQuoteRepository.deleteCategory(params));
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return a Failure from repository', () async {
    when(mockQuoteRepository.deleteCategory(params))
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await deleteCategory(params);

    expect(result, equals(Left(CacheFailure())));
  });
}
