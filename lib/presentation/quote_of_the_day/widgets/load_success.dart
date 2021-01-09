import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/presentation/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:NeQuo/presentation/shared/action_button.dart';
import 'package:NeQuo/presentation/shared/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadSuccess extends StatelessWidget {
  final Function close;
  final Function share;
  final SuccessState state;
  final FavoriteBloc favoriteBloc;

  const LoadSuccess({
    @required this.close,
    @required this.state,
    @required this.share,
    @required this.favoriteBloc,
  });

  void handleFavorite() {
    favoriteBloc.add(
      AddFavoriteEvent(
        favorite: Favorite(
          author: state.quote.author,
          content: state.quote.content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            icon: Icons.close_outlined,
            onPress: close,
            align: Alignment.topRight,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Text(
                  state.quote.content,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '-${state.quote.author}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
          Column(
            children: [
              BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  if (state is FavoriteLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FavoriteErrorState) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)
                            .translate('add_fav_error')),
                      ),
                    );
                    return ActionButton(
                      icon: Icons.favorite_outline,
                      onPress: handleFavorite,
                    );
                  } else if (state is FavoriteSuccessState) {
                    return ActionButton(
                      icon: Icons.favorite,
                      onPress: () {},
                    );
                  } else {
                    return ActionButton(
                      icon: Icons.favorite_outline,
                      onPress: handleFavorite,
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              ActionButton(
                icon: Icons.share_outlined,
                onPress: share,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
