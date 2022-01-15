import 'package:nequo/presentation/details/widgets/options_menu.dart';
import 'package:flutter/material.dart';

import 'package:nequo/app_localizations.dart';

class EmptyWidget extends StatelessWidget {
  final Function getQuotesList;
  final Function handleDeleteQuoteList;

  const EmptyWidget({
    Key? key,
    required this.getQuotesList,
    required this.handleDeleteQuoteList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: Key("empty_widget_safe_area"),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                OptionsMenu(
                  getQuotesList: getQuotesList,
                  handleDeleteQuoteList: handleDeleteQuoteList,
                ),
              ],
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
