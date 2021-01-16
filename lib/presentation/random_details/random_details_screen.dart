import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/presentation/random_details/widgets/empty_widget.dart';
import 'package:NeQuo/presentation/random_details/widgets/success_widget.dart';
import 'package:NeQuo/presentation/shared/widgets/load_error_widget.dart';
import 'package:NeQuo/presentation/shared/widgets/loading_widget.dart';
import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/usecases/load_random_quotes.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_bloc.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_event.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_state.dart';
import 'package:NeQuo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomDetailsScreen extends StatefulWidget {
  @override
  _RandomDetailsScreenState createState() => _RandomDetailsScreenState();
}

class _RandomDetailsScreenState extends State<RandomDetailsScreen> {
  RandomDetailsBloc _randomDetailsBloc;
  FavoriteBloc _favoriteBloc;
  ShareQuote share;

  @override
  void initState() {
    super.initState();

    _randomDetailsBloc = getIt<RandomDetailsBloc>();
    _favoriteBloc = getIt<FavoriteBloc>();
    share = getIt<ShareQuote>();

    getRandomQuotes(0, 0);
  }

  @override
  void dispose() {
    super.dispose();

    _randomDetailsBloc.close();
    _favoriteBloc.close();
  }

  void getRandomQuotes(int skip, int scrollPos) {
    _randomDetailsBloc.add(
      GetRandomQuotes(
        params: LoadRandomQuotesParams(skip: skip),
        scrollPos: scrollPos,
      ),
    );
  }

  void handleFavorite(Favorite fav, int index) async {
    _favoriteBloc.add(
      AddFavoriteEvent(
        favorite: fav,
        index: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("random_details_screen"),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _randomDetailsBloc,
          ),
          BlocProvider(
            create: (_) => _favoriteBloc,
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: BlocBuilder<RandomDetailsBloc, RandomDetailsState>(
            builder: (context, state) {
              if (state is EmptyState) {
                return EmptyWidget(
                  key: Key("emtpy_widget"),
                );
              } else if (state is LoadingState) {
                return LoadingWidget(key: Key("loading_widget"));
              } else if (state is SuccessState) {
                return SuccessWidget(
                  key: Key("success_widget"),
                  getRandomQuotes: getRandomQuotes,
                  handleFavorite: handleFavorite,
                  share: share,
                  state: state,
                );
              } else {
                return LoadErrorWidget(
                  key: Key("load_error_widget"),
                  text: AppLocalizations.of(context).translate("load_ql_error"),
                  retry: () {
                    getRandomQuotes(0, 0);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
