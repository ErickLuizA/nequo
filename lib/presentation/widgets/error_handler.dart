import 'package:flutter/material.dart';
import 'package:nequo/app_localizations.dart';

class ErrorHandler extends StatelessWidget {
  final String text;
  final String? continueText;
  final String? retryText;
  final void Function()? onContinue;
  final void Function()? onRetry;

  ErrorHandler({
    Key? key,
    required this.text,
    this.retryText,
    this.onRetry,
    this.continueText,
    this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key("load_error_widget_column"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.report_gmailerrorred,
          color: Theme.of(context).colorScheme.error,
          size: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
        TextButton(
          key: Key("try_again_button"),
          child: Text(
              retryText ?? AppLocalizations.of(context).translate("try_again")),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              Theme.of(context).textTheme.bodyText2?.color,
            ),
          ),
          onPressed: onRetry,
        ),
        if (onContinue != null)
          TextButton(
            child: Text(continueText ??
                AppLocalizations.of(context).translate("continue")),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).textTheme.bodyText2?.color,
              ),
            ),
            onPressed: onContinue,
          ),
      ],
    );
  }
}
