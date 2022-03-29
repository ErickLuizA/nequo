import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/quote.dart';

import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/widgets/quote_details.dart';

import 'bloc/details_bloc.dart';
import 'bloc/details_state.dart';

class DetailsScreen extends StatelessWidget {
  final ShareQuote share;
  final Quote quote;

  const DetailsScreen({
    Key? key,
    required this.share,
    required this.quote,
  }) : super(key: key);

  void handleCopy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: quote.content));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).translate('copied_to_clipboard'),
        ),
      ),
    );
  }

  void handleShare(String text) {
    share(
      ShareParams(
        text: text,
        subject: 'nequo - Quotes app',
      ),
    );
  }

  void handleAddFavorite(BuildContext context) {}

  void handleDeleteFavorite(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate('favorites')),
      ),
      body: Padding(
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
            return QuoteDetails(
              quote: quote,
              share: () => handleShare(quote.content),
              handleCopy: () => handleCopy(context),
              handleAddFavorite: () => handleAddFavorite(context),
              handleDeleteFavorite: () => handleDeleteFavorite(context),
            );
          },
        ),
      ),
    );
  }
}
