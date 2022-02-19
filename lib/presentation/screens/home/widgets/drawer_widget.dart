import 'package:nequo/app_localizations.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final Function handleNavigateToFavorites;
  final Function navigateToQuoteOfTheDay;
  final Function handleShare;

  const DrawerWidget({
    Key? key,
    required this.handleNavigateToFavorites,
    required this.navigateToQuoteOfTheDay,
    required this.handleShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        children: [
          ListTile(
            textColor: Theme.of(context).colorScheme.onBackground,
            iconColor: Theme.of(context).colorScheme.onBackground,
            onTap: () {
              navigateToQuoteOfTheDay();
            },
            title: Text(
                AppLocalizations.of(context).translate('quote_of_the_day')),
            leading: Icon(
              Icons.format_quote,
            ),
          ),
          ListTile(
            textColor: Theme.of(context).colorScheme.onBackground,
            iconColor: Theme.of(context).colorScheme.onBackground,
            onTap: () {
              handleNavigateToFavorites();
            },
            title: Text(AppLocalizations.of(context).translate('favorites')),
            leading: Icon(
              Icons.favorite_outline,
            ),
          ),
          ListTile(
            textColor: Theme.of(context).colorScheme.onBackground,
            iconColor: Theme.of(context).colorScheme.onBackground,
            onTap: () {
              handleShare();
            },
            title: Text(AppLocalizations.of(context).translate('share')),
            leading: Icon(
              Icons.share,
            ),
          ),
        ],
      ),
    );
  }
}
