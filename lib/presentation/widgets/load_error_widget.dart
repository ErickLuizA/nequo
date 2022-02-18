import 'package:nequo/app_localizations.dart';
import 'package:flutter/material.dart';

class LoadErrorWidget extends StatelessWidget {
  final String text;
  final void Function()? retry;

  LoadErrorWidget({
    Key? key,
    required this.text,
    this.retry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key("load_error_widget_column"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning,
          color: Colors.orange[700],
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
          ),
        ),
        MaterialButton(
          key: Key("try_again_button"),
          child: Text(AppLocalizations.of(context).translate("try_again")),
          minWidth: MediaQuery.of(context).size.width / 2,
          color: Theme.of(context).indicatorColor,
          textColor: Colors.white,
          onPressed: retry,
        ),
      ],
    );
  }
}
