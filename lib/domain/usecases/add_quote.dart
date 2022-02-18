import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class AddQuoteParams {
  final String content;
  final String author;
  final int? categoryId;

  const AddQuoteParams({
    required this.content,
    required this.author,
    required this.categoryId,
  });
}

class AddQuote implements UseCase<void, AddQuoteParams> {
  QuoteRepository quoteRepository;

  AddQuote({required this.quoteRepository});

  @override
  Future<Either<Failure, Quote>> call(AddQuoteParams params) async {
    return await quoteRepository.save(params);
  }
}
