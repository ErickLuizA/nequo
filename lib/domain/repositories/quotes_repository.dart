import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/load_quote.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class AddQuoteParams {
  final int id;
  final String content;
  final String author;
  final String authorSlug;

  const AddQuoteParams({
    required this.id,
    required this.content,
    required this.author,
    required this.authorSlug,
  });
}

abstract class QuoteRepository {
  Future<Either<Failure, Quote>> findQuoteOfTheDay();

  Future<Either<Failure, Quote>> findOne(LoadQuoteParams params);

  Future<Either<Failure, PaginatedResponse<List<Quote>>>> findAll(
      LoadQuotesParams params);

  Future<Either<Failure, Quote>> findRandom();

  Future<Either<Failure, Quote>> save(AddQuoteParams params);
}
