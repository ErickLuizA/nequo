import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/usecase.dart';

abstract class QuotesRemoteDatasource {
  Future<Quote> findQuoteOfTheDay();

  Future<Quote> findRandom();

  Future<Quote> findOne({required int id});

  Future<PaginatedResponse<List<Quote>>> findAll(LoadQuotesParams params);
}
