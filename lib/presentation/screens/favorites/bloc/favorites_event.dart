import 'package:nequo/domain/entities/quote.dart';

abstract class FavoritesEvent {}

class GetFavorites extends FavoritesEvent {}

class DeleteFavoriteEvent extends FavoritesEvent {
  final int id;

  DeleteFavoriteEvent({required this.id});
}

class PermanentDeleteFavoriteEvent extends FavoritesEvent {
  final List<Quote> quotes;
  final int id;

  PermanentDeleteFavoriteEvent({
    required this.quotes,
    required this.id,
  });
}

class UndoDeleteFavoriteEvent extends FavoritesEvent {
  final List<Quote> quotes;
  final int id;

  UndoDeleteFavoriteEvent({
    required this.quotes,
    required this.id,
  });
}
