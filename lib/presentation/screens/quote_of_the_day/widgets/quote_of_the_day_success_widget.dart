import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/widgets/favorite_buton.dart';
import 'package:nequo/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';

class QuoteOfTheDaySuccessWidget extends StatelessWidget {
  final void Function() close;
  final void Function() share;

  final Quote quote;

  const QuoteOfTheDaySuccessWidget({
    Key? key,
    required this.close,
    required this.quote,
    required this.share,
  }) : super(key: key);

  void handleAddFavorite(BuildContext context) {
    context.read<QuoteOfTheDayBloc>().add(AddToFavorites(quote.id));
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ActionButton(
              icon: Icons.close_outlined,
              onPress: close,
              align: Alignment.topRight,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.format_quote,
                          size: 30,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        quote.content,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 10),
                      Icon(
                        Icons.format_quote,
                        size: 30,
                        color: Theme.of(context).colorScheme.onBackground,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '-${quote.author}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FavoriteButton(
                  addFavorite: () => handleAddFavorite(context),
                  deleteFavorite: () => handleDeleteFavorite(context),
                  quote: quote,
                ),
                SizedBox(
                  width: 20,
                ),
                ActionButton(
                  icon: Icons.share_outlined,
                  onPress: share,
                ),
                SizedBox(
                  width: 20,
                ),
                ActionButton(
                  icon: Icons.copy,
                  onPress: () => handleCopy(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
