import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/domain/errors/failures.dart';
import 'package:NeQuo/domain/repositories/quote_repository.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';

class AddQuoteList implements UseCase<void, QuoteList> {
  QuoteRepository quoteListRepository;

  AddQuoteList({
    @required this.quoteListRepository,
  });

  @override
  Future<Either<Failure, void>> call(QuoteList params) async {
    return await quoteListRepository.addQuoteList(params);
  }
}
