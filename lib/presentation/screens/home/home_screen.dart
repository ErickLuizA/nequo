import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/widgets/load_error_widget.dart';
import 'package:nequo/presentation/widgets/loading_widget.dart';
import 'package:nequo/service_locator.dart';

import 'bloc/home_bloc.dart';
import 'widgets/drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  final HomeBloc homeBloc;
  final ShareQuote share;
  final AddCategory addCategory;
  final AddQuote addQuote;

  const HomeScreen({
    Key? key,
    required this.homeBloc,
    required this.share,
    required this.addCategory,
    required this.addQuote,
  }) : super(key: key);

  void handleNavigateToFavorites(BuildContext context) {
    Navigator.of(context).pushNamed('/favorites');
  }

  void handleNavigateToQuoteOfTheDay(BuildContext context) {
    Navigator.of(context).pushNamed('/quote_of_the_day');
  }

  void handleShare(BuildContext context) async {
    await share(ShareParams(
      subject: 'nequo - Quotes App',
      text: AppLocalizations.of(context).translate('find_quotes'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerWidget(
        handleNavigateToFavorites: () {
          handleNavigateToFavorites(context);
        },
        navigateToQuoteOfTheDay: () {
          handleNavigateToQuoteOfTheDay(context);
        },
        handleShare: () {
          handleShare(context);
        },
      ),
      appBar: AppBar(
        title: Text('Nequo'),
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
    );
  }
}