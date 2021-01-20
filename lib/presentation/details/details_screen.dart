import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote_list.dart';
import 'package:NeQuo/presentation/details/bloc/delete_bloc.dart';
import 'package:NeQuo/presentation/details/bloc/delete_event.dart';
import 'package:NeQuo/presentation/details/widgets/empty_widget.dart';
import 'package:NeQuo/presentation/details/widgets/success_widget.dart';
import 'package:NeQuo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:NeQuo/presentation/shared/widgets/load_error_widget.dart';
import 'package:NeQuo/presentation/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/domain/usecases/load_quotes.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/details/bloc/details_bloc.dart';
import 'package:NeQuo/presentation/details/bloc/details_event.dart';
import 'package:NeQuo/presentation/details/bloc/details_state.dart';

class DetailsScreen extends StatefulWidget {
  final QuoteList quoteList;
  final Function getQuotesList;

  const DetailsScreen({
    Key key,
    this.quoteList,
    this.getQuotesList,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  DetailsBloc _detailsBloc;
  FavoriteBloc _favoriteBloc;
  DeleteBloc _deleteBloc;

  ShareQuote share;

  @override
  void initState() {
    super.initState();

    _detailsBloc = getIt<DetailsBloc>();
    _favoriteBloc = getIt<FavoriteBloc>();

    _deleteBloc = getIt<DeleteBloc>();

    share = getIt<ShareQuote>();

    getQuotes();
  }

  @override
  void dispose() {
    super.dispose();

    _detailsBloc.close();
    _favoriteBloc.close();
    _deleteBloc.close();
  }

  void getQuotes() {
    _detailsBloc.add(
      GetQuotes(
        params: LoadQuotesParams(id: widget.quoteList.id),
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

  void handleDeleteQuote(DeleteQuoteParams params) async {
    _deleteBloc.add(
      DeleteQuoteEvent(params: params),
    );
  }

  void handleDeleteQuoteList() async {
    _deleteBloc.add(
      DeleteQuoteListEvent(
        params: DeleteQuoteListParams(id: widget.quoteList.id),
      ),
    );
  }

  void shareQuote(String text) {
    share(
      ShareParams(
        text: text,
        subject: 'NeQuo - Quotes app',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("details_screen"),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _detailsBloc,
          ),
          BlocProvider(
            create: (_) => _favoriteBloc,
          ),
          BlocProvider(
            create: (_) => _deleteBloc,
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: BlocBuilder<DetailsBloc, DetailsState>(
            builder: (context, state) {
              if (state is EmptyState) {
                return EmptyWidget(
                  key: Key("empty_widget"),
                  getQuotesList: widget.getQuotesList,
                  handleDeleteQuoteList: handleDeleteQuoteList,
                );
              } else if (state is LoadingState) {
                return LoadingWidget();
              } else if (state is SuccessState) {
                return SuccessWidget(
                  getQuotes: getQuotes,
                  getQuotesList: widget.getQuotesList,
                  handleDeleteQuote: handleDeleteQuote,
                  handleDeleteQuoteList: handleDeleteQuoteList,
                  handleFavorite: handleFavorite,
                  shareQuote: shareQuote,
                  successState: state,
                );
              } else {
                return LoadErrorWidget(
                  retry: getQuotes,
                  text: AppLocalizations.of(context)
                      .translate("load_quote_error"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
