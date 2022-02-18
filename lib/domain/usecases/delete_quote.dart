import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class DeleteQuoteParams {
  int id;

  DeleteQuoteParams({required this.id});
}

class DeleteQuote extends UseCase<void, DeleteQuoteParams> {
  QuoteRepository quoteRepository;

  DeleteQuote({
    required this.quoteRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeleteQuoteParams params) async {
    return await quoteRepository.delete(params);
  }
}
