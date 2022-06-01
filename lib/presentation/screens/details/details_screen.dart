import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/widgets/error_handler.dart';
import 'package:nequo/presentation/widgets/loading_indicator.dart';
import 'package:nequo/presentation/widgets/quote_actions.dart';
import 'package:nequo/presentation/widgets/quote_details.dart';

import 'bloc/details_bloc.dart';
import 'bloc/details_event.dart';
import 'bloc/details_state.dart';

class DetailsScreen extends StatefulWidget {
  final ShareQuote share;
  final int? quoteId;

  DetailsScreen({
    Key? key,
    required this.share,
    this.quoteId,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late bool isRandom;

  @override
  void initState() {
    super.initState();

    isRandom = widget.quoteId == null;

    handleGetQuote();
  }

  void handleGetQuote() {
    context.read<DetailsBloc>().add(GetQuoteEvent(id: widget.quoteId));
  }

  void handleCopy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).translate('copied_to_clipboard'),
        ),
      ),
    );
  }

  void handleShare(String text) {
    widget.share(
      ShareParams(
        text: text,
        subject: 'Nequo - Quotes app',
      ),
    );
  }

  void handleAddFavorite(BuildContext context, Quote quote) {
    context.read<DetailsBloc>().add(AddToFavorites(quote));
  }

  void handleDeleteFavorite(BuildContext context, int quoteId) {
    context.read<DetailsBloc>().add(DeleteFromFavorites(quoteId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          isRandom
              ? AppLocalizations.of(context).translate('random_quote')
              : AppLocalizations.of(context).translate('details'),
        ),
        actions: [
          if (isRandom)
            IconButton(
              icon: Icon(Icons.shuffle_outlined),
              onPressed: handleGetQuote,
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<DetailsBloc, DetailsState>(
          listener: (context, state) {
            if (state.actionStatus == DetailsActionStatus.favoriteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('add_fav_error'),
                  ),
                ),
              );
            }

            if (state.actionStatus == DetailsActionStatus.unfavoriteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('del_fav_error'),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return LoadingIndicator();
            }

            if (state.hasError) {
              return ErrorHandler(
                text: state.error,
                onRetry: handleGetQuote,
              );
            }

            if (state.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  QuoteDetails(
                    quote: state.quote,
                  ),
                  SizedBox(height: 10),
                  QuoteActions(
                    isFavorited: state.quote.isFavorited,
                    share: () => handleShare(state.quote.content),
                    handleCopy: () => handleCopy(context, state.quote.content),
                    handleAddFavorite: () =>
                        handleAddFavorite(context, state.quote),
                    handleDeleteFavorite: () =>
                        handleDeleteFavorite(context, state.quote.id),
                  )
                ],
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
