import 'package:flutter/material.dart';

import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/widgets/action_button.dart';
import 'package:nequo/presentation/widgets/favorite_buton.dart';

class QuoteDetails extends StatelessWidget {
  final Quote quote;
  final void Function() share;
  final void Function() handleCopy;
  final void Function() handleAddFavorite;
  final void Function() handleDeleteFavorite;

  const QuoteDetails({
    Key? key,
    required this.quote,
    required this.share,
    required this.handleCopy,
    required this.handleAddFavorite,
    required this.handleDeleteFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FavoriteButton(
              addFavorite: handleAddFavorite,
              deleteFavorite: handleDeleteFavorite,
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
              onPress: handleCopy,
            ),
          ],
        ),
      ],
    );
  }
}
