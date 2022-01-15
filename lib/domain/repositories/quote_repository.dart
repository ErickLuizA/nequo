import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/delete_quote_list.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';
import 'package:dartz/dartz.dart';

abstract class QuoteRepository {
  Future<Either<Failure, Quote>> getRandom();

  Future<Either<Failure, List<Quote>>> getRandomQuotes(
      LoadRandomQuotesParams params);

  Future<Either<Failure, List<QuoteList>>> getQuotesList();

  Future<Either<Failure, List<Quote>>> getQuotes(LoadQuotesParams params);

  Future<Either<Failure, void>> addQuote(AddQuoteParams params);

  Future<Either<Failure, void>> addQuoteList(QuoteList params);

  Future<Either<Failure, void>> deleteQuote(DeleteQuoteParams params);

  Future<Either<Failure, void>> deleteQuoteList(DeleteQuoteListParams params);
}
