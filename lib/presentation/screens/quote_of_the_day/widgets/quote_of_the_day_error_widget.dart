import 'package:nequo/app_localizations.dart';
import 'package:flutter/material.dart';

class QuoteOfTheDayErrorWidget extends StatelessWidget {
  final void Function() navigate;
  final void Function() retry;

  const QuoteOfTheDayErrorWidget({
    Key? key,
    required this.navigate,
    required this.retry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_amber_outlined,
          color: Colors.deepOrangeAccent,
          size: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: Text(
            AppLocalizations.of(context).translate('load_qod_error'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 18,
            ),
          ),
        ),
        TextButton(
          child: Text(
            AppLocalizations.of(context).translate('try_again'),
          ),
          style: TextButton.styleFrom(
            primary: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: retry,
        ),
        TextButton(
          child: Text(AppLocalizations.of(context).translate('continue')),
          style: TextButton.styleFrom(
            primary: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: navigate,
        ),
      ],
    );
  }
}
