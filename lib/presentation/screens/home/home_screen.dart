import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/screens/home/bloc/home_event.dart';
import 'package:nequo/presentation/widgets/load_error_widget.dart';
import 'package:nequo/presentation/widgets/loading_widget.dart';
import 'package:nequo/presentation/widgets/quote_card.dart';

import 'bloc/home_bloc.dart';
import 'bloc/home_state.dart';
import 'widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  final ShareQuote share;
  final AddQuote addQuote;

  const HomeScreen({
    Key? key,
    required this.share,
    required this.addQuote,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    handleGetQuotes();

    super.initState();
  }

  void handleNavigateToFavorites(BuildContext context) {
    Navigator.of(context).pushNamed('/favorites');
  }

  void handleNavigateToQuoteOfTheDay(BuildContext context) {
    Navigator.of(context).pushNamed('/quote_of_the_day');
  }

  void handleShare(BuildContext context) async {
    await widget.share(
      ShareParams(
        subject: 'nequo - Quotes App',
        text: AppLocalizations.of(context).translate('find_quotes'),
      ),
    );
  }

  void handleGetQuotes() {
    context.read<HomeBloc>().add(GetQuotesEvent());
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
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          print(state.uiStatus);

          if (state.isLoading) {
            return LoadingWidget();
          }

          if (state.hasError) {
            return LoadErrorWidget(text: 'Error');
          }

          if (state.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: state.quotes.length,
              itemBuilder: (context, index) {
                final quote = state.quotes[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: QuoteCard(
                    quote: quote,
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
