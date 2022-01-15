import 'package:nequo/domain/entities/quote_list.dart';
import 'package:dartz/dartz.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadQuotesList implements UseCase<List<QuoteList>, NoParams> {
  QuoteRepository quoteRepository;

  LoadQuotesList({
    required this.quoteRepository,
  });

  @override
  Future<Either<Failure, List<QuoteList>>> call(NoParams params) async {
    return await quoteRepository.getQuotesList();
  }
}
