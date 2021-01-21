import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/presentation/favorites/widgets/success_widget.dart';
import 'package:NeQuo/presentation/shared/widgets/empty_widget.dart';
import 'package:NeQuo/presentation/shared/widgets/loading_widget.dart';
import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/usecases/delete_favorite.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_bloc.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_event.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_state.dart';
import 'package:NeQuo/presentation/shared/widgets/load_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoritesBloc _favoritesBloc;
  ShareQuote share;

  @override
  void initState() {
    super.initState();

    _favoritesBloc = getIt<FavoritesBloc>();
    share = getIt<ShareQuote>();

    getFavorites();
  }

  @override
  void dispose() {
    super.dispose();

    _favoritesBloc.close();
  }

  void getFavorites() {
    _favoritesBloc.add(GetFavorites());
  }

  void shareQuote(String text) {
    share(
      ShareParams(
        text: text,
        subject: 'NeQuo - Quotes app',
      ),
    );
  }

  void deleteFavorite(int id) {
    _favoritesBloc.add(
      DeleteFavoriteEvent(params: DeleteFavoriteParams(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("favorites_screen"),
      body: BlocProvider(
        create: (_) => _favoritesBloc,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
            if (state is EmptyState) {
              return EmptyWidget(key: Key("empty_widget"));
            } else if (state is FailedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    key: Key("failed_snackbar"),
                    content: Text(
                      AppLocalizations.of(context).translate('del_fav_error'),
                    ),
                  ),
                );
              });

              return LoadingWidget(key: Key("loading_widget_failure"));
            } else if (state is LoadingState) {
              return LoadingWidget(key: Key("loading_widget"));
            } else if (state is SuccessState) {
              return SuccessWidget(
                key: Key("success_widget"),
                deleteFavorite: deleteFavorite,
                shareQuote: shareQuote,
                state: state,
              );
            } else {
              return LoadErrorWidget(
                key: Key("load_error_widget"),
                retry: getFavorites,
                text: AppLocalizations.of(context).translate("load_fav_error"),
              );
            }
          }),
        ),
      ),
    );
  }
}
