import 'package:NeQuo/domain/usecases/delete_favorite.dart';
import 'package:NeQuo/domain/usecases/load_favorites.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_event.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  LoadFavorites loadFavorites;
  DeleteFavorite deleteFavorite;

  FavoritesBloc({
    @required this.loadFavorites,
    @required this.deleteFavorite,
  }) : super(InitialState());

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    if (event is GetFavorites) {
      yield LoadingState();

      final result = await loadFavorites(NoParams());

      yield result.fold(
        (failure) => ErrorState(),
        (success) {
          if (success.isEmpty) {
            return EmptyState();
          } else {
            return SuccessState(favorites: success);
          }
        },
      );
    } else if (event is DeleteFavoriteEvent) {
      yield LoadingState();

      final result = await deleteFavorite(event.params);

      if (result.isLeft()) {
        yield FailedState();
        add(GetFavorites());
      } else {
        add(GetFavorites());
      }
    }
  }
}
