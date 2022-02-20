import 'package:nequo/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:nequo/presentation/widgets/action_button.dart';

class DrawerWidget extends StatefulWidget {
  final Function handleNavigateToFavorites;
  final Function navigateToQuoteOfTheDay;
  final Function handleShare;

  DrawerWidget({
    Key? key,
    required this.handleNavigateToFavorites,
    required this.navigateToQuoteOfTheDay,
    required this.handleShare,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    final curveAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween(
      begin: Offset(2.5, -2.5),
      end: Offset.zero,
    ).animate(curveAnimation);

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void handleCloseDrawer(BuildContext context) async {
    await controller.reverse();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: SizedBox(
        width: double.infinity,
        child: Drawer(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 20,
                ),
                child: ActionButton(
                  icon: Icons.close,
                  align: Alignment.centerRight,
                  onPress: () => handleCloseDrawer(context),
                ),
              ),
              ListTile(
                textColor: Theme.of(context).colorScheme.onBackground,
                iconColor: Theme.of(context).colorScheme.onBackground,
                onTap: () {
                  widget.navigateToQuoteOfTheDay();
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
                  widget.handleNavigateToFavorites();
                },
                title:
                    Text(AppLocalizations.of(context).translate('favorites')),
                leading: Icon(
                  Icons.favorite_outline,
                ),
              ),
              ListTile(
                textColor: Theme.of(context).colorScheme.onBackground,
                iconColor: Theme.of(context).colorScheme.onBackground,
                onTap: () {
                  widget.handleShare();
                },
                title: Text(
                  AppLocalizations.of(context).translate('share'),
                ),
                leading: Icon(
                  Icons.share,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
