import 'package:flutter/material.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/presentation/widgets/action_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeDrawer extends StatefulWidget {
  final Function() handleShare;

  HomeDrawer({
    Key? key,
    required this.handleShare,
  }) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer>
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

  void handleNavigateToFavorites() {
    Navigator.of(context).pushNamed('/favorites');
  }

  void handleNavigateToQuoteOfTheDay() {
    Navigator.of(context).pushNamed('/quote_of_the_day');
  }

  void handleNavigateToRandomQuote() {
    Navigator.of(context).pushNamed('/details');
  }

  void handleCloseDrawer() async {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        top: 20,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ActionButton(
                          icon: Icons.close,
                          align: Alignment.centerRight,
                          onPress: handleCloseDrawer,
                        ),
                      ),
                    ),
                    ListTile(
                      textColor: Theme.of(context).colorScheme.onBackground,
                      iconColor: Theme.of(context).colorScheme.onBackground,
                      onTap: handleNavigateToQuoteOfTheDay,
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('quote_of_the_day'),
                      ),
                      leading: Icon(Icons.format_quote),
                    ),
                    ListTile(
                      textColor: Theme.of(context).colorScheme.onBackground,
                      iconColor: Theme.of(context).colorScheme.onBackground,
                      onTap: handleNavigateToRandomQuote,
                      title: Text(
                        AppLocalizations.of(context).translate('random_quote'),
                      ),
                      leading: Icon(Icons.shuffle_outlined),
                    ),
                    ListTile(
                      textColor: Theme.of(context).colorScheme.onBackground,
                      iconColor: Theme.of(context).colorScheme.onBackground,
                      onTap: handleNavigateToFavorites,
                      title: Text(
                        AppLocalizations.of(context).translate('favorites'),
                      ),
                      leading: Icon(Icons.favorite_outline),
                    ),
                    ListTile(
                      textColor: Theme.of(context).colorScheme.onBackground,
                      iconColor: Theme.of(context).colorScheme.onBackground,
                      onTap: widget.handleShare,
                      title:
                          Text(AppLocalizations.of(context).translate('share')),
                      leading: Icon(Icons.share),
                    ),
                  ],
                ),
              ),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 20),
                      child: Text(
                        "nequo ${snapshot.data!.version}",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
