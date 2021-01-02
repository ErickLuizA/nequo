import 'package:dartz/dartz.dart';

import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

class LoadQuotesParams {
  final int id;

  LoadQuotesParams({
    this.id,
  });
}

class LoadQuotes extends UseCase<List<Quote>, LoadQuotesParams> {
  QuoteRepository quoteRepository;

  LoadQuotes({
    this.quoteRepository,
  });

  @override
  Future<Either<Failure, List<Quote>>> call(LoadQuotesParams params) async {
    return await quoteRepository.getQuotes(params);
  }
}
