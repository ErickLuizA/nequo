import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/load_categories.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  LoadCategories loadCategories;
  MockQuoteRepository mockQuoteRepository;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    loadCategories = LoadCategories(quoteRepository: mockQuoteRepository);
  });

  test('should call quoteRepository.getCategories with given params', () async {
    await loadCategories(NoParams());

    verify(mockQuoteRepository.getCategories());
    verifyNoMoreInteractions(mockQuoteRepository);
  });

  test('should return a List<Quote> from repository', () async {
    when(mockQuoteRepository.getCategories())
        .thenAnswer((_) async => Right(List<Category>()));

    final result = await loadCategories(NoParams());

    expect(result, isA<Right<Failure, List<Category>>>());
  });

  test('should return a Failure from repository', () async {
    when(mockQuoteRepository.getCategories())
        .thenAnswer((_) async => Left(CacheFailure()));

    final result = await loadCategories(NoParams());

    expect(result, equals(Left(CacheFailure())));
  });
}
