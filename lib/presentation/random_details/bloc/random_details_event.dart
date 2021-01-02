import 'package:NeQuo/domain/usecases/load_random_quotes.dart';

abstract class RandomDetailsEvent {}

class GetRandomQuotes extends RandomDetailsEvent {
  LoadRandomQuotesParams params;
  int scrollPos;

  GetRandomQuotes({
    this.params,
    this.scrollPos,
  });
}
