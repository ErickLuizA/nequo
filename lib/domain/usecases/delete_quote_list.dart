import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class DeleteQuoteListParams {
  int id;

  DeleteQuoteListParams({
    required this.id,
  });
}

class DeleteQuoteList extends UseCase<void, DeleteQuoteListParams> {
  QuoteRepository quoteRepository;

  DeleteQuoteList({
    required this.quoteRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeleteQuoteListParams params) async {
    return await quoteRepository.deleteQuoteList(params);
  }
}
