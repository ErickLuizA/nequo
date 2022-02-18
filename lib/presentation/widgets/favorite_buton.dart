import 'package:flutter/material.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'action_button.dart';

class FavoriteButton extends StatelessWidget {
  final void Function() addFavorite;
  final void Function() deleteFavorite;

  final Quote quote;

  const FavoriteButton({
    Key? key,
    required this.quote,
    required this.deleteFavorite,
    required this.addFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      icon: quote.isFavorited ? Icons.favorite : Icons.favorite_outline,
      onPress: () {
        if (quote.isFavorited) {
          deleteFavorite();
        } else {
          addFavorite();
        }
      },
    );
  }
}
