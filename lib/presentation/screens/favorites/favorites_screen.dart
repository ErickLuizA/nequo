import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/share_quote.dart';

import 'bloc/favorites_bloc.dart';
import 'bloc/favorites_event.dart';
import 'bloc/favorites_state.dart';

class FavoritesScreen extends StatefulWidget {
  final FavoritesBloc favoritesBloc;
  final ShareQuote share;

  const FavoritesScreen({
    Key? key,
    required this.favoritesBloc,
    required this.share,
  }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    getFavorites();
  }

  void getFavorites() {
    widget.favoritesBloc.add(GetFavorites());
  }

  void shareQuote(String text) {
    widget.share(
      ShareParams(
        text: text,
        subject: 'nequo - Quotes app',
      ),
    );
  }

  void deleteFavorite(int id) {
    widget.favoritesBloc.add(
      DeleteFavoriteEvent(params: DeleteFavoriteParams(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("favorites_screen"),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: BlocConsumer<FavoritesBloc, FavoritesState>(
            listener: (context, state) {},
            builder: (context, state) {
              // if (state is EmptyState) {
              //   return EmptyWidget(key: Key("empty_widget"));
              // } else if (state is FailedState) {
              //   WidgetsBinding.instance?.addPostFrameCallback((_) {
              //     Scaffold.of(context).showSnackBar(
              //       SnackBar(
              //         key: Key("failed_snackbar"),
              //         content: Text(
              //           AppLocalizations.of(context).translate('del_fav_error'),
              //         ),
              //       ),
              //     );
              //   });

              //   return LoadingWidget(key: Key("loading_widget_failure"));
              // } else if (state is LoadingState) {
              //   return LoadingWidget(key: Key("loading_widget"));
              // } else if (state is SuccessState) {
              //   return SuccessWidget(
              //     key: Key("success_widget"),
              //     deleteFavorite: deleteFavorite,
              //     shareQuote: shareQuote,
              //     state: state,
              //   );
              // } else {
              //   return LoadErrorWidget(
              //     key: Key("load_error_widget"),
              //     retry: getFavorites,
              //     text:
              //         AppLocalizations.of(context).translate("load_fav_error"),
              //   );
              // }

              return Text("Favorites");
            }),
      ),
    );
  }
}
