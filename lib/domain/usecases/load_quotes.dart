import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadQuotes implements UseCase<List<Quote>, NoParams> {
  QuoteRepository quoteRepository;

  LoadQuotes({required this.quoteRepository});

  @override
  Future<Either<Failure, List<Quote>>> call(NoParams params) async {
    return await quoteRepository.findAll();
  }
}
