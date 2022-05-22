import 'package:flutter/material.dart';

import 'action_button.dart';
import 'favorite_buton.dart';

class QuoteActions extends StatelessWidget {
  final bool isFavorited;
  final void Function() share;
  final void Function() handleCopy;
  final void Function() handleAddFavorite;
  final void Function() handleDeleteFavorite;

  const QuoteActions({
    Key? key,
    required this.isFavorited,
    required this.share,
    required this.handleCopy,
    required this.handleAddFavorite,
    required this.handleDeleteFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FavoriteButton(
            addFavorite: handleAddFavorite,
            deleteFavorite: handleDeleteFavorite,
            isFavorited: isFavorited,
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
    );
  }
}
