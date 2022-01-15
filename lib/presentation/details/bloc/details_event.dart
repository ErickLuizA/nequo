import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';

abstract class DetailsEvent {}

class GetQuotes extends DetailsEvent {
  LoadQuotesParams params;

  GetQuotes({
    required this.params,
  });
}

class GetRandomQuotes extends DetailsEvent {
  LoadRandomQuotesParams params;

  GetRandomQuotes({
    required this.params,
  });
}
