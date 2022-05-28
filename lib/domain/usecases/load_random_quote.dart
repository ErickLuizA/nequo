import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadRandomQuote extends UseCase<Quote, NoParams> {
  final QuoteRepository quoteRepository;

  LoadRandomQuote({required this.quoteRepository});

  @override
  Future<Either<Failure, Quote>> call(NoParams params) async {
    return quoteRepository.findRandom();
  }
}
