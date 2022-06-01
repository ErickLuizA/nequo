import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/update_quote.dart';

class SaveQuoteParams {
  final AddQuoteParams params;

  SaveQuoteParams({
    required this.params,
  });
}

abstract class QuotesLocalDatasource {
  Future<Quote> findQuoteOfTheDay();

  Future<Quote> findOne({required int id});

  Future<Quote?> findByServerId({required int serverId});

  Future<List<Quote>> findAll({required bool isFeed});

  Future<Quote> save({
    required AddQuoteParams params,
  });

  Future<List<Quote>> saveAll({
    required List<SaveQuoteParams> params,
    bool replace,
  });

  Future<Quote> update(UpdateQuoteParams params);

  Future<void> delete(DeleteQuoteParams params);

  Future<void> saveQuoteOfTheDay({
    required AddQuoteParams params,
  });
}
