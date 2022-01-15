import 'package:nequo/app_localizations.dart';
import 'package:flutter/material.dart';

class LoadError extends StatelessWidget {
  final Function navigate;
  final Function retry;

  const LoadError({
    Key? key,
    required this.navigate,
    required this.retry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key("load_error_container"),
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
            AppLocalizations.of(context).translate('load_qod_error'),
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        MaterialButton(
          key: Key("try_again_button"),
          child: Text(AppLocalizations.of(context).translate('try_again')),
          minWidth: MediaQuery.of(context).size.width / 2,
          color: Theme.of(context).indicatorColor,
          textColor: Colors.white,
          onPressed: () {
            retry();
          },
        ),
        SizedBox(height: 10),
        MaterialButton(
          key: Key("continue_button"),
          child: Text(AppLocalizations.of(context).translate('continue')),
          minWidth: MediaQuery.of(context).size.width / 2,
          color: Theme.of(context).indicatorColor,
          textColor: Colors.white,
          onPressed: () {
            navigate();
          },
        ),
      ],
    );
  }
}
