import 'package:nequo/domain/entities/quote.dart';

abstract class QuoteOfTheDayEvent {}

class GetQuoteOfTheDay extends QuoteOfTheDayEvent {}

class AddToFavorites extends QuoteOfTheDayEvent {
  final Quote quote;

  AddToFavorites(this.quote);
}

class DeleteFromFavorites extends QuoteOfTheDayEvent {
  final int quoteId;

  DeleteFromFavorites(this.quoteId);
}
