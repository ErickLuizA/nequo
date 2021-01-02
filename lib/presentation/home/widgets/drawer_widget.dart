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
      child: ListView(
        children: [
          ListTile(
            onTap: handleNavigateToFavorites,
            title: Text('Favorites'),
            leading: Icon(
              Icons.favorite_outline,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: handleShare,
            title: Text('Share'),
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
