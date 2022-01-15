import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadRandomQuotesParams {
  final int skip;

  LoadRandomQuotesParams({
    required this.skip,
  });
}

class LoadRandomQuotes implements UseCase<List<Quote>, LoadRandomQuotesParams> {
  QuoteRepository quoteRepository;

  LoadRandomQuotes({required this.quoteRepository});

  @override
  Future<Either<Failure, List<Quote>>> call(
      LoadRandomQuotesParams params) async {
    return await quoteRepository.getRandomQuotes(params);
  }
}
