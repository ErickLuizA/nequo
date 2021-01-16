import 'package:NeQuo/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  EmptyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty_outlined,
                    size: 50,
                  ),
                  Text(AppLocalizations.of(context).translate("empty_list")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
