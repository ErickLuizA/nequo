import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/load_quote.dart';
import 'package:dartz/dartz.dart';
import 'package:nequo/domain/usecases/update_quote.dart';

abstract class QuoteRepository {
  Future<Either<Failure, Quote>> findQuoteOfTheDay();

  Future<Either<Failure, Quote>> findOne(LoadQuoteParams params);

  Future<Either<Failure, List<Quote>>> findAll();

  Future<Either<Failure, Quote>> save(AddQuoteParams params);

  Future<Either<Failure, Quote>> update(UpdateQuoteParams params);

  Future<Either<Failure, void>> delete(DeleteQuoteParams params);
}
