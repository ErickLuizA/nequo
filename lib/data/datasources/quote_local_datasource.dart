import 'package:nequo/data/models/quote_list_model.dart';
import 'package:nequo/data/models/quote_model.dart';
import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/delete_quote_list.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';

abstract class QuoteLocalDatasource {
  Future<QuoteModel> getLastQuote();

  Future<void> cacheQuote(QuoteModel quoteModel);

  Future<List<QuoteModel>> getCachedQuotes(LoadQuotesParams params);

  Future<List<QuoteListModel>> getCachedQuoteList();

  Future<void> addQuoteList(QuoteList params);

  Future<void> addQuote(AddQuoteParams params);

  Future<void> deleteQuote(DeleteQuoteParams params);

  Future<void> deleteQuoteList(DeleteQuoteListParams params);
}
