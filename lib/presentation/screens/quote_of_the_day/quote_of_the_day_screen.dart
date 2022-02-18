import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/widgets/quote_of_the_day_error_widget.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/widgets/quote_of_the_day_success_widget.dart';

import 'package:nequo/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuoteOfTheDayScreen extends StatefulWidget {
  final ShareQuote shareQuote;

  const QuoteOfTheDayScreen({
    required this.shareQuote,
  });

  @override
  _QuoteOfTheDayScreenState createState() => _QuoteOfTheDayScreenState();
}

class _QuoteOfTheDayScreenState extends State<QuoteOfTheDayScreen> {
  @override
  void initState() {
    super.initState();

    handleLoadRandomQuote();
  }

  void handleLoadRandomQuote() {
    context.read<QuoteOfTheDayBloc>().add(GetQuoteOfTheDay());
  }

  void handleShare(String text) {
    widget.shareQuote(
      ShareParams(
        text: text,
        subject: 'nequo - Quotes app',
      ),
    );
  }

  void handleClose() {
    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: BlocConsumer<QuoteOfTheDayBloc, QuoteOfTheDayState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.isLoading) {
              return LoadingWidget();
            }

            if (state.hasError) {
              return QuoteOfTheDayErrorWidget(
                navigate: handleClose,
                retry: handleLoadRandomQuote,
              );
            }

            if (state.hasData) {
              return QuoteOfTheDaySuccessWidget(
                close: handleClose,
                share: () {
                  handleShare(state.quote!.content);
                },
                quote: state.quote!,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
