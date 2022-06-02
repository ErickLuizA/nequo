import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';

class SaveQuoteParams {
  final AddQuoteParams params;

  SaveQuoteParams({
    required this.params,
  });
}

abstract class QuotesLocalDatasource {
  Future<Quote> findQuoteOfTheDay();

  Future<Quote> findOne({required int id});

  Future<List<Quote>> findAll({required bool isFeed});

  Future<Quote> findRandom();

  Future<Quote> save({
    required AddQuoteParams params,
  });

  Future<List<Quote>> saveAll({
    required List<SaveQuoteParams> params,
    bool replace,
  });

  Future<void> saveQuoteOfTheDay({
    required AddQuoteParams params,
  });
}
