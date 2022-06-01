import 'package:nequo/domain/entities/quote.dart';

abstract class DetailsEvent {}

class GetQuoteEvent extends DetailsEvent {
  final int? id;

  GetQuoteEvent({
    this.id,
  });
}

class AddToFavorites extends DetailsEvent {
  final Quote quote;

  AddToFavorites(this.quote);
}

class DeleteFromFavorites extends DetailsEvent {
  final int quoteId;

  DeleteFromFavorites(this.quoteId);
}
