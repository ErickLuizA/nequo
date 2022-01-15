import 'package:nequo/domain/entities/favorite.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:nequo/presentation/quote_of_the_day/widgets/load_error.dart';
import 'package:nequo/presentation/quote_of_the_day/widgets/load_success.dart';
import 'package:nequo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:nequo/presentation/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/service_locator.dart';

class QuoteOfTheDayScreen extends StatefulWidget {
  @override
  _QuoteOfTheDayScreenState createState() => _QuoteOfTheDayScreenState();
}

class _QuoteOfTheDayScreenState extends State<QuoteOfTheDayScreen> {
  late QuoteOfTheDayBloc _quoteOfTheDayBloc;
  late FavoriteBloc _favoriteBloc;
  late ShareQuote share;

  @override
  void initState() {
    super.initState();

    _quoteOfTheDayBloc = getIt<QuoteOfTheDayBloc>();
    _favoriteBloc = getIt<FavoriteBloc>();

    share = getIt<ShareQuote>();

    handleLoadQuote();
  }

  @override
  void dispose() {
    super.dispose();

    _quoteOfTheDayBloc.close();
    _favoriteBloc.close();
  }

  void handleLoadQuote() {
    _quoteOfTheDayBloc.add(GetRandomQuote());
  }

  void handleNavigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void addFavorite(Favorite favorite) {
    _favoriteBloc.add(AddFavoriteEvent(favorite: favorite));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _quoteOfTheDayBloc,
          ),
          BlocProvider(
            create: (_) => _favoriteBloc,
          ),
        ],
        child: Container(
          key: Key("quod_container"),
          color: Theme.of(context).primaryColor,
          child: BlocBuilder<QuoteOfTheDayBloc, QuoteOfTheDayState>(
            builder: (_, state) {
              if (state is LoadingState) {
                return LoadingWidget(key: Key("loading"));
              } else if (state is SuccessState) {
                return LoadSuccess(
                  key: Key("load_success"),
                  close: handleNavigateToHome,
                  addFavorite: addFavorite,
                  share: () {
                    share(
                      ShareParams(
                        text: state.quote.content,
                        subject: 'nequo - Quotes app',
                      ),
                    );
                  },
                  state: state,
                );
              } else {
                return LoadError(
                  key: Key("load_error"),
                  navigate: handleNavigateToHome,
                  retry: handleLoadQuote,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
