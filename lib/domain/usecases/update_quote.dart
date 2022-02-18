import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class UpdateQuoteParams {
  final String? content;
  final String? author;
  final int? categoryId;

  UpdateQuoteParams({
    this.content,
    this.author,
    this.categoryId,
  });
}

class UpdateQuote extends UseCase<Quote, UpdateQuoteParams> {
  final QuoteRepository quoteRepository;

  UpdateQuote({required this.quoteRepository});

  @override
  Future<Either<Failure, Quote>> call(UpdateQuoteParams params) async {
    return await quoteRepository.update(params);
  }
}
