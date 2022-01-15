import 'package:bloc/bloc.dart';

import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';

class FavoriteState {
  List<int> favIndex;

  FavoriteState({
    required this.favIndex,
  });
}

class FavoriteLoadingState extends FavoriteState {
  FavoriteLoadingState({
    required List<int> favIndex,
  }) : super(favIndex: favIndex);
}

class FavoriteSuccessState extends FavoriteState {
  FavoriteSuccessState({
    required List<int> favIndex,
  }) : super(favIndex: favIndex);
}

class FavoriteErrorState extends FavoriteState {
  FavoriteErrorState({
    required List<int> favIndex,
  }) : super(favIndex: favIndex);
}

abstract class FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent {
  Favorite favorite;
  int? index;

  AddFavoriteEvent({
    required this.favorite,
    this.index,
  });
}

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  AddFavorite addFavorite;

  FavoriteBloc({
    required this.addFavorite,
  }) : super(FavoriteState(favIndex: [])) {
    on<AddFavoriteEvent>(_onAddFavoriteEvent);
  }

  List<int> _favIndex = [];

  void _onAddFavoriteEvent(
    AddFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await addFavorite(event.favorite);

    if (result.isRight()) {
      if (event.index != null) {
        _favIndex.add(event.index!);
      }
    }

    result.fold(
      (l) => emit(FavoriteErrorState(favIndex: _favIndex)),
      (r) => emit(FavoriteSuccessState(favIndex: _favIndex)),
    );
  }
}
