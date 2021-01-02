import 'package:NeQuo/data/models/quote_model.dart';
import 'package:NeQuo/domain/usecases/load_random_quotes.dart';

abstract class QuoteRemoteDatasource {
  Future<QuoteModel> getRandom();

  Future<List<QuoteModel>> getQuotes(LoadRandomQuotesParams params);
}
