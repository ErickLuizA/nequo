import 'package:flutter/material.dart';

import 'action_button.dart';

class FavoriteButton extends StatelessWidget {
  final void Function() addFavorite;
  final void Function() deleteFavorite;

  final bool isFavorited;

  const FavoriteButton({
    Key? key,
    required this.isFavorited,
    required this.deleteFavorite,
    required this.addFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      icon: isFavorited ? Icons.favorite : Icons.favorite_outline,
      onPress: () {
        if (isFavorited) {
          deleteFavorite();
        } else {
          addFavorite();
        }
      },
    );
  }
}
