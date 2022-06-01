import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadQuoteParams {
  final int id;
  final bool isServer;

  LoadQuoteParams({required this.id, this.isServer = true});
}

class LoadQuote extends UseCase<Quote, LoadQuoteParams> {
  QuoteRepository quoteRepository;

  LoadQuote({required this.quoteRepository});

  @override
  Future<Either<Failure, Quote>> call(LoadQuoteParams params) async {
    return await quoteRepository.findOne(params);
  }
}
