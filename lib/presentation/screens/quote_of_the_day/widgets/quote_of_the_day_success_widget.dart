import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/widgets/favorite_buton.dart';
import 'package:nequo/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';

class QuoteOfTheDaySuccessWidget extends StatelessWidget {
  final Function close;
  final Function share;

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
                  child: Text(
                    quote.content,
                    style: Theme.of(context).textTheme.bodyText1,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
