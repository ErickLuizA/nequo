import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:dartz/dartz.dart';
import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

class LoadQuotesList implements UseCase<List<QuoteList>, NoParams> {
  QuoteRepository quoteRepository;

  LoadQuotesList({
    this.quoteRepository,
  });

  @override
  Future<Either<Failure, List<QuoteList>>> call(NoParams params) async {
    return await quoteRepository.getQuotesList();
  }
}
