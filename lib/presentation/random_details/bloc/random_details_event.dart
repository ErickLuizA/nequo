import 'package:nequo/domain/usecases/load_random_quotes.dart';

abstract class RandomDetailsEvent {}

class GetRandomQuotes extends RandomDetailsEvent {
  LoadRandomQuotesParams params;
  int scrollPos;

  GetRandomQuotes({
    required this.params,
    required this.scrollPos,
  });
}
