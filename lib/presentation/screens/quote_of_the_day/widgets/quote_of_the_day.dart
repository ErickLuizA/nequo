import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/widgets/action_button.dart';
import 'package:nequo/presentation/widgets/quote_actions.dart';
import 'package:nequo/presentation/widgets/quote_details.dart';

class QuoteOfTheDay extends StatelessWidget {
  final void Function() close;
  final void Function() share;

  final Quote quote;

  const QuoteOfTheDay({
    Key? key,
    required this.close,
    required this.quote,
    required this.share,
  }) : super(key: key);

  void handleAddFavorite(BuildContext context) {
    context.read<QuoteOfTheDayBloc>().add(AddToFavorites(quote));
  }

  void handleDeleteFavorite(BuildContext context) {
    context.read<QuoteOfTheDayBloc>().add(DeleteFromFavorites(quote.id));
  }

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionButton(
                icon: Icons.close_outlined,
                onPress: close,
                align: Alignment.topRight,
              ),
              QuoteDetails(
                quote: quote,
              ),
              QuoteActions(
                isFavorited: quote.isFavorited,
                share: share,
                handleCopy: () => handleCopy(context),
                handleAddFavorite: () => handleAddFavorite(context),
                handleDeleteFavorite: () => handleDeleteFavorite(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
