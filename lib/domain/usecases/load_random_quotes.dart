import 'package:dartz/dartz.dart';
import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

class LoadRandomQuotesParams {
  final int skip;

  LoadRandomQuotesParams({
    this.skip,
  });
}

class LoadRandomQuotes implements UseCase<List<Quote>, LoadRandomQuotesParams> {
  QuoteRepository quoteRepository;

  LoadRandomQuotes({this.quoteRepository});

  @override
  Future<Either<Failure, List<Quote>>> call(
      LoadRandomQuotesParams params) async {
    return await quoteRepository.getRandomQuotes(params);
  }
}
