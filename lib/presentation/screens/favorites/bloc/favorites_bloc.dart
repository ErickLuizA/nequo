import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/load_favorites.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  LoadFavorites loadFavorites;
  DeleteFavorite deleteFavorite;

  FavoritesBloc({
    required this.loadFavorites,
    required this.deleteFavorite,
  }) : super(
          FavoritesState(favorites: [], uiStatus: FavoritesUIStatus.initial),
        ) {
    on<GetFavorites>(_onGetFavorites);
    on<DeleteFavoriteEvent>(_onDeleteFavoriteEvent);
  }

  _onGetFavorites(
    GetFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(uiStatus: FavoritesUIStatus.loading));

    final result = await loadFavorites(NoParams());

    emit(result.fold(
      (failure) => state.copyWith(
        uiStatus: FavoritesUIStatus.error,
        error: 'error',
      ),
      (favorites) {
        if (favorites.isEmpty) {
          return state.copyWith(
            uiStatus: FavoritesUIStatus.loading,
            favorites: [],
            error: '',
          );
        } else {
          return state.copyWith(
            uiStatus: FavoritesUIStatus.loading,
            favorites: favorites,
            error: '',
          );
        }
      },
    ));
  }

  _onDeleteFavoriteEvent(
    DeleteFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentList = state.favorites;

    emit(
      state.copyWith(
        uiStatus: FavoritesUIStatus.loading,
        favorites: state.favorites
            .where((element) => element.id != event.params.id)
            .toList(),
        error: '',
      ),
    );

    final result = await deleteFavorite(event.params);

    if (result.isLeft()) {
      emit(
        state.copyWith(
          uiStatus: FavoritesUIStatus.loading,
          favorites: currentList,
          error: 'error deleting',
        ),
      );
    }
  }
}
