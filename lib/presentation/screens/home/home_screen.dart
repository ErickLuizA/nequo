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

  void handleShare(BuildContext context) async {
    await share(ShareParams(
      subject: 'nequo - Quotes App',
      text: AppLocalizations.of(context).translate('find_quotes'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      endDrawer: DrawerWidget(
        handleNavigateToFavorites: handleNavigateToFavorites,
        handleShare: handleShare,
      ),
      appBar: AppBar(
        title: Text(
          "nequo",
          style: GoogleFonts.marckScript(
            fontSize: 32,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        key: Key("home_screen"),
        mainAxisSize: MainAxisSize.min,
        children: [],
      ),
      floatingActionButton: Builder(
        builder: (scaffoldContext) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: scaffoldContext,
              backgroundColor: Color(0XFF605c65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              builder: (context) {
                return Text("hello");
              },
            );
          },
        ),
      ),
    );
  }
}
