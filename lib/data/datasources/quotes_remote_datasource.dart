import 'package:nequo/domain/entities/quote.dart';

abstract class QuotesRemoteDatasource {
  Future<Quote> findQuoteOfTheDay();

  // Future<Quote> findOne(int id);

  Future<List<Quote>> findAll();

  // Future<Quote> save(AddQuoteParams params);

  // Future<Quote> update();

  // Future<void> delete(DeleteQuoteParams params);
}
