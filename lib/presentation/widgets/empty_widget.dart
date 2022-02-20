import 'package:nequo/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty_outlined,
            size: 50,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).translate("empty_list"),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
