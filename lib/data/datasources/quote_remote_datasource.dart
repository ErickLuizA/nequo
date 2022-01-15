import 'package:nequo/data/models/quote_model.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';

abstract class QuoteRemoteDatasource {
  Future<QuoteModel> getRandom();

  Future<List<QuoteModel>> getQuotes(LoadRandomQuotesParams params);
}
