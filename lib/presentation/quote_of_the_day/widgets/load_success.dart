import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:nequo/presentation/shared/widgets/action_button.dart';
import 'package:nequo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:nequo/presentation/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadSuccess extends StatelessWidget {
  final Function close;
  final Function share;
  final SuccessState state;
  final Function(Favorite favorite) addFavorite;

  const LoadSuccess({
    Key? key,
    required this.close,
    required this.state,
    required this.share,
    required this.addFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        key: Key("load_success_container"),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ActionButton(
              key: Key("close_button"),
              icon: Icons.close_outlined,
              onPress: close,
              align: Alignment.topRight,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, favState) {
                    if (favState is FavoriteLoadingState) {
                      return LoadingWidget(key: Key("loading_state"));
                    } else if (favState is FavoriteSuccessState) {
                      return ActionButton(
                        key: Key("success_state"),
                        icon: Icons.favorite,
                        onPress: () {},
                      );
                    } else if (favState is FavoriteErrorState) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            key: Key("snackbar"),
                            content: Text(
                              AppLocalizations.of(context)
                                  .translate('add_fav_error'),
                            ),
                          ),
                        );
                      });

                      return ActionButton(
                        key: Key("error_state"),
                        icon: Icons.favorite_outline,
                        onPress: () {
                          addFavorite(
                            Favorite(
                              author: state.quote.author,
                              content: state.quote.content,
                            ),
                          );
                        },
                      );
                    } else {
                      return ActionButton(
                        key: Key("favorite_button"),
                        icon: Icons.favorite_outline,
                        onPress: () {
                          addFavorite(
                            Favorite(
                              author: state.quote.author,
                              content: state.quote.content,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                ActionButton(
                  key: Key("share_button"),
                  icon: Icons.share_outlined,
                  onPress: share,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
