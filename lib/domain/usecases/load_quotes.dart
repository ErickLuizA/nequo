import 'package:dartz/dartz.dart';

import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadQuotesParams {
  final int id;

  LoadQuotesParams({
    required this.id,
  });
}

class LoadQuotes extends UseCase<List<Quote>, LoadQuotesParams> {
  QuoteRepository quoteRepository;

  LoadQuotes({
    required this.quoteRepository,
  });

  @override
  Future<Either<Failure, List<Quote>>> call(LoadQuotesParams params) async {
    return await quoteRepository.getQuotes(params);
  }
}
