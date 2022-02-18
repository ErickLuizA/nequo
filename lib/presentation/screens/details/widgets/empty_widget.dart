import 'package:flutter/material.dart';

import 'package:nequo/app_localizations.dart';

import 'options_menu.dart';

class EmptyWidget extends StatelessWidget {
  final Function getCategories;
  final Function handleDeleteCategory;

  const EmptyWidget({
    Key? key,
    required this.getCategories,
    required this.handleDeleteCategory,
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
                  getCategories: getCategories,
                  handleDeleteCategory: handleDeleteCategory,
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
