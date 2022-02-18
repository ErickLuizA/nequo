abstract class QuoteOfTheDayEvent {}

class GetQuoteOfTheDay extends QuoteOfTheDayEvent {}

class AddToFavorites extends QuoteOfTheDayEvent {
  final int quoteId;

  AddToFavorites(this.quoteId);
}

class DeleteFromFavorites extends QuoteOfTheDayEvent {
  final int quoteId;

  DeleteFromFavorites(this.quoteId);
}
