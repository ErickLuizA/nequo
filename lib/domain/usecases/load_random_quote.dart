import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';

class LoadRandomQuote implements UseCase<Quote, NoParams> {
  final QuoteRepository quoteRepository;

  LoadRandomQuote({
    required this.quoteRepository,
  });

  @override
  Future<Either<Failure, Quote>> call(NoParams params) async {
    return await quoteRepository.getRandom();
  }
}
