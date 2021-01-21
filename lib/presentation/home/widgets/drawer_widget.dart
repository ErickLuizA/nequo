import 'package:NeQuo/app_localizations.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final Function handleNavigateToFavorites;
  final Function handleShare;

  const DrawerWidget({
    Key key,
    @required this.handleNavigateToFavorites,
    @required this.handleShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: Key("drawer"),
      child: ListView(
        children: [
          ListTile(
            key: Key("list_tile_navigation"),
            onTap: handleNavigateToFavorites,
            title: Text(AppLocalizations.of(context).translate('favorites')),
            leading: Icon(
              Icons.favorite_outline,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            key: Key("list_tile_share"),
            onTap: handleShare,
            title: Text(AppLocalizations.of(context).translate('share')),
            leading: Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
