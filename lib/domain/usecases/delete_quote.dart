import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

class DeleteQuoteParams {
  int id;

  DeleteQuoteParams({
    @required this.id,
  });
}

class DeleteQuote extends UseCase<void, DeleteQuoteParams> {
  QuoteRepository quoteRepository;

  DeleteQuote({
    this.quoteRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeleteQuoteParams params) async {
    return await quoteRepository.deleteQuote(params);
  }
}
