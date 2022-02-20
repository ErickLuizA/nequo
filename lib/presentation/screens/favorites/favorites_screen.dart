import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/quote.dart';

import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/widgets/empty_widget.dart';
import 'package:nequo/presentation/widgets/load_error_widget.dart';
import 'package:nequo/presentation/widgets/loading_widget.dart';

import 'bloc/favorites_bloc.dart';
import 'bloc/favorites_event.dart';
import 'bloc/favorites_state.dart';
import 'widgets/success_widget.dart';

class FavoritesScreen extends StatefulWidget {
  final ShareQuote share;

  const FavoritesScreen({
    Key? key,
    required this.share,
  }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    getFavorites();

    super.initState();
  }

  void getFavorites() {
    context.read<FavoritesBloc>().add(GetFavorites());
  }

  void shareQuote(String text) {
    widget.share(
      ShareParams(
        text: text,
        subject: 'nequo - Quotes app',
      ),
    );
  }

  void deleteFavorite(int id,
      {bool isPermanent = false, List<Quote> quotes = const []}) {
    if (isPermanent) {
      context
          .read<FavoritesBloc>()
          .add(PermanentDeleteFavoriteEvent(id: id, quotes: quotes));
    } else {
      context.read<FavoritesBloc>().add(DeleteFavoriteEvent(id: id));
    }
  }

  void undoDeleteFavorite(int id, List<Quote> quotes) {
    context
        .read<FavoritesBloc>()
        .add(UndoDeleteFavoriteEvent(id: id, quotes: quotes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('favorites')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<FavoritesBloc, FavoritesState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.isLoading) {
              return LoadingWidget();
            }

            if (state.isEmpty) {
              return EmptyWidget();
            }

            if (state.hasError) {
              return LoadErrorWidget(
                text: AppLocalizations.of(context).translate(
                  "load_fav_error",
                ),
              );
            }

            if (state.hasData) {
              return SuccessWidget(
                favorites: state.favorites,
                deleteFavorite: deleteFavorite,
                undoDeleteFavorite: undoDeleteFavorite,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
