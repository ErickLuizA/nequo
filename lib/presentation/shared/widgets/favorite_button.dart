import 'package:NeQuo/presentation/random_details/bloc/random_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:NeQuo/presentation/shared/widgets/action_button.dart';

class FavoriteButton extends StatelessWidget {
  final int current;
  final Function(Favorite fav, int index) handleFavorite;
  final SuccessState state;

  const FavoriteButton({
    Key key,
    @required this.current,
    @required this.handleFavorite,
    @required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favState) {
        final isFavorite = favState.favIndex.contains(current);

        return isFavorite
            ? ActionButton(
                icon: Icons.favorite,
                onPress: () {},
              )
            : ActionButton(
                icon: Icons.favorite_outline,
                onPress: () {
                  handleFavorite(
                    Favorite(
                      author: state.quotes[current].author,
                      content: state.quotes[current].content,
                    ),
                    current,
                  );
                },
              );
      },
    );
  }
}
