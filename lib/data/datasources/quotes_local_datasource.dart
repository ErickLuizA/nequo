import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/update_quote.dart';

abstract class QuotesLocalDatasource {
  Future<Quote> findQuoteOfTheDay();

  Future<Quote> findOne({required int id});

  Future<List<Quote>> findAll();

  Future<Quote> save({
    int? serverId,
    required AddQuoteParams params,
  });

  Future<Quote> update(UpdateQuoteParams params);

  Future<void> delete(DeleteQuoteParams params);

  Future<void> saveQuoteOfTheDay({
    int? serverId,
    required AddQuoteParams params,
  });
}
