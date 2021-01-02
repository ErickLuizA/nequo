import 'package:NeQuo/domain/entities/quote.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

// ignore: must_be_immutable
class AddQuoteParams extends Quote {
  final int id;
  final String content;
  final String author;
  final int listId;

  AddQuoteParams({
    this.id,
    this.content,
    this.author,
    this.listId,
  });
}

class AddQuote implements UseCase<void, AddQuoteParams> {
  QuoteRepository quoteRepository;

  AddQuote({
    @required this.quoteRepository,
  });

  @override
  Future<Either<Failure, void>> call(AddQuoteParams params) async {
    return await quoteRepository.addQuote(params);
  }
}
