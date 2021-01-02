import 'package:NeQuo/domain/usecases/load_quotes.dart';
import 'package:NeQuo/domain/usecases/load_random_quotes.dart';

abstract class DetailsEvent {}

class GetQuotes extends DetailsEvent {
  LoadQuotesParams params;

  GetQuotes({
    this.params,
  });
}

class GetRandomQuotes extends DetailsEvent {
  LoadRandomQuotesParams params;

  GetRandomQuotes({
    this.params,
  });
}
