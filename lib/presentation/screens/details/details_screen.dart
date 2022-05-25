import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/widgets/quote_actions.dart';
import 'package:nequo/presentation/widgets/quote_details.dart';

import 'bloc/details_bloc.dart';
import 'bloc/details_event.dart';
import 'bloc/details_state.dart';

class DetailsScreen extends StatefulWidget {
  final ShareQuote share;
  final int quoteId;

  DetailsScreen({
    Key? key,
    required this.share,
    required this.quoteId,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();

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
        subject: 'nequo - Quotes app',
      ),
    );
  }

  void handleAddFavorite(BuildContext context) {
    context.read<DetailsBloc>().add(AddToFavorites(widget.quoteId));
  }

  void handleDeleteFavorite(BuildContext context) {
    context.read<DetailsBloc>().add(DeleteFromFavorites(widget.quoteId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('details')),
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
                  handleAddFavorite: () => handleAddFavorite(context),
                  handleDeleteFavorite: () => handleDeleteFavorite(context),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
