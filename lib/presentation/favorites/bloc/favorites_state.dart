import 'package:nequo/domain/entities/favorite.dart';

abstract class FavoritesState {}

class InitialState extends FavoritesState {}

class LoadingState extends FavoritesState {}

class SuccessState extends FavoritesState {
  List<Favorite> favorites;

  SuccessState({
    required this.favorites,
  });
}

class EmptyState extends FavoritesState {}

class ErrorState extends FavoritesState {}

class FailedState extends FavoritesState {}
