import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/load_favorites.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:nequo/presentation/favorites/bloc/favorites_event.dart';
import 'package:nequo/presentation/favorites/bloc/favorites_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  LoadFavorites loadFavorites;
  DeleteFavorite deleteFavorite;

  FavoritesBloc({
    required this.loadFavorites,
    required this.deleteFavorite,
  }) : super(InitialState()) {
    on<GetFavorites>(_onGetFavorites);
    on<DeleteFavoriteEvent>(_onDeleteFavoriteEvent);
  }

  _onGetFavorites(
    GetFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(LoadingState());

    final result = await loadFavorites(NoParams());

    emit(result.fold(
      (failure) => ErrorState(),
      (success) {
        if (success.isEmpty) {
          return EmptyState();
        } else {
          return SuccessState(favorites: success);
        }
      },
    ));
  }

  _onDeleteFavoriteEvent(
    DeleteFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(LoadingState());

    final result = await deleteFavorite(event.params);

    if (result.isLeft()) {
      emit(FailedState());
      add(GetFavorites());
    } else {
      add(GetFavorites());
    }
  }
}
