import 'package:nequo/domain/usecases/delete_favorite.dart';

abstract class FavoritesEvent {}

class GetFavorites extends FavoritesEvent {}

class DeleteFavoriteEvent extends FavoritesEvent {
  final DeleteFavoriteParams params;
  DeleteFavoriteEvent({
    required this.params,
  });
}
