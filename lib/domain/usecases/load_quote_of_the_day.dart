import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadQuoteOfTheDay implements UseCase<Quote, NoParams> {
  final QuoteRepository quoteRepository;

  LoadQuoteOfTheDay({required this.quoteRepository});

  @override
  Future<Either<Failure, Quote>> call(NoParams params) async {
    return await quoteRepository.findQuoteOfTheDay();
  }
}
