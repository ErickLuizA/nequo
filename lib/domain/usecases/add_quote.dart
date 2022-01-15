import 'package:nequo/domain/entities/quote.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class AddQuoteParams {
  final String content;
  final String author;
  final int listId;

  const AddQuoteParams({
    required this.content,
    required this.author,
    required this.listId,
  });
}

class AddQuote implements UseCase<void, AddQuoteParams> {
  QuoteRepository quoteRepository;

  AddQuote({
    required this.quoteRepository,
  });

  @override
  Future<Either<Failure, void>> call(AddQuoteParams params) async {
    return await quoteRepository.addQuote(params);
  }
}
