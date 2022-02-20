import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nequo/domain/usecases/share_quote.dart';

import 'bloc/details_bloc.dart';
import 'bloc/details_state.dart';

class DetailsScreen extends StatelessWidget {
  final ShareQuote share;

  const DetailsScreen({
    Key? key,
    required this.share,
  }) : super(key: key);

  // void getQuotes() {
  //   _detailsBloc.add(
  //     GetQuotes(
  //       params: LoadQuotesParams(id: widget.quoteList!.id!),
  //     ),
  //   );
  // }

  // void handleFavorite(Quote fav, int index) async {
  //   _favoriteBloc.add(
  //     AddFavoriteEvent(
  //       favorite: fav,
  //       index: index,
  //     ),
  //   );
  // }

  // void handleDeleteQuote(DeleteQuoteParams params) async {
  //   _deleteBloc.add(
  //     DeleteQuoteEvent(params: params),
  //   );
  // }

  // void handleDeleteCategory() async {
  //   _deleteBloc.add(
  //     DeleteCategoryEvent(
  //       params: DeleteCategoryParams(id: widget.quoteList!.id!),
  //     ),
  //   );
  // }

  void shareQuote(String text) {
    share(
      ShareParams(
        text: text,
        subject: 'nequo - Quotes app',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("details_screen"),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child:
            BlocBuilder<DetailsBloc, DetailsState>(builder: (context, state) {
          //   if (state is EmptyState) {
          //     return EmptyWidget(
          //       key: Key("empty_widget"),
          //       getCategories: widget.getCategories!,
          //       handleDeleteCategory: handleDeleteCategory,
          //     );
          //   } else if (state is LoadingState) {
          //     return LoadingWidget(
          //       key: Key("loading_widget"),
          //     );
          //   } else if (state is SuccessState) {
          //     return Text("Sucesso");

          //     // return SuccessWidget(
          //     //   key: Key("success_widget"),
          //     //   getQuotes: getQuotes,
          //     //   getCategories: widget.getCategories!,
          //     //   handleDeleteQuote: handleDeleteQuote,
          //     //   handleDeleteCategory: handleDeleteCategory,
          //     //   handleFavorite: handleFavorite,
          //     //   shareQuote: shareQuote,
          //     //   successState: state,
          //     // );
          //   } else {
          //     return LoadErrorWidget(
          //       key: Key("load_error_widget"),
          //       retry: () {},
          //       text:
          //           AppLocalizations.of(context).translate("load_quote_error"),
          //     );
          //   }
          // },

          return Text('hi');
        }),
      ),
    );
  }
}
