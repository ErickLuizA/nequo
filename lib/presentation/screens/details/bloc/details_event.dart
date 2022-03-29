abstract class DetailsEvent {}

class GetQuoteEvent extends DetailsEvent {
  final int id;

  GetQuoteEvent({
    required this.id,
  });
}

class AddToFavorites extends DetailsEvent {
  final int quoteId;

  AddToFavorites(this.quoteId);
}

class DeleteFromFavorites extends DetailsEvent {
  final int quoteId;

  DeleteFromFavorites(this.quoteId);
}
