import 'package:bloc/bloc.dart';

import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/usecases/add_favorite.dart';

class FavoriteState {
  List<int> favIndex;

  FavoriteState({
    this.favIndex,
  });
}

class FavoriteLoadingState extends FavoriteState {
  FavoriteLoadingState({
    List<int> favIndex,
  }) : super(favIndex: favIndex);
}

class FavoriteSuccessState extends FavoriteState {
  FavoriteSuccessState({
    List<int> favIndex,
  }) : super(favIndex: favIndex);
}

class FavoriteErrorState extends FavoriteState {
  FavoriteErrorState({
    List<int> favIndex,
  }) : super(favIndex: favIndex);
}

abstract class FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent {
  Favorite favorite;
  int index;

  AddFavoriteEvent({
    this.favorite,
    this.index,
  });
}

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  AddFavorite addFavorite;

  FavoriteBloc({
    this.addFavorite,
  }) : super(
          FavoriteState(
            favIndex: List<int>(),
          ),
        );

  List<int> favIndex = List();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is AddFavoriteEvent) {
      final result = await addFavorite(event.favorite);

      if(result.isRight()) {
        favIndex.add(event.index);
      }

      yield result.fold(
        (l) => FavoriteErrorState(favIndex: favIndex),
        (r) => FavoriteSuccessState(favIndex: favIndex),
      );
    }
  }
}
