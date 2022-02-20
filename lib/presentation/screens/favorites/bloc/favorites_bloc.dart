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
          FavoritesState(
            favorites: [],
            uiStatus: FavoritesUIStatus.initial,
          ),
        ) {
    on<GetFavorites>(_onGetFavorites);
    on<DeleteFavoriteEvent>(_onDeleteFavoriteEvent);
    on<PermanentDeleteFavoriteEvent>(_onPermanentDeleteFavoriteEvent);
    on<UndoDeleteFavoriteEvent>(_onUndoDeleteFavoriteEvent);
  }

  Future<void> _onGetFavorites(
    GetFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(uiStatus: FavoritesUIStatus.loading));

    final result = await loadFavorites(NoParams());

    emit(
      result.fold(
        (failure) => state.copyWith(
          uiStatus: FavoritesUIStatus.error,
          error: 'error',
        ),
        (favorites) => favorites.isEmpty
            ? state.copyWith(
                uiStatus: FavoritesUIStatus.empty,
                favorites: favorites,
                error: '',
              )
            : state.copyWith(
                uiStatus: FavoritesUIStatus.success,
                favorites: favorites,
                error: '',
              ),
      ),
    );
  }

  void _onDeleteFavoriteEvent(
    DeleteFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentList = state.favorites;

    emit(
      state.copyWith(
        favorites:
            state.favorites.where((element) => element.id != event.id).toList(),
        previousFavorites: currentList,
        error: '',
      ),
    );
  }

  Future<void> _onPermanentDeleteFavoriteEvent(
    PermanentDeleteFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await deleteFavorite(DeleteFavoriteParams(id: event.id));

    if (result.isLeft()) {
      emit(
        state.copyWith(
          actionStatus: FavoritesActionStatus.deleteError,
          favorites: state.previousFavorites,
          previousFavorites: [],
        ),
      );
    } else {
      emit(state.copyWith(
        actionStatus: FavoritesActionStatus.initial,
        uiStatus:
            state.favorites.isEmpty ? FavoritesUIStatus.empty : state.uiStatus,
        previousFavorites: [],
      ));
    }
  }

  void _onUndoDeleteFavoriteEvent(
    UndoDeleteFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) {
    emit(
      state.copyWith(
        actionStatus: FavoritesActionStatus.initial,
        favorites: state.previousFavorites,
        previousFavorites: [],
      ),
    );
  }
}
