import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/add_quote_list.dart';
import 'package:flutter/material.dart';

import 'package:nequo/presentation/home/widgets/add_quote_bottom_sheet.dart';
import 'package:nequo/presentation/home/widgets/add_quote_list_bottom_sheet.dart';

class BottomSheetWidget extends StatelessWidget {
  final List<QuoteList> list;
  final BuildContext scaffoldContext;
  final Function getQuotesList;
  final AddQuoteList addQuoteList;
  final AddQuote addQuote;

  const BottomSheetWidget({
    Key? key,
    required this.list,
    required this.scaffoldContext,
    required this.getQuotesList,
    required this.addQuoteList,
    required this.addQuote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: Key("bottom_sheet"),
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 15,
      children: [
        TextButton(
          key: Key("open_add_quote_list_bottom_sheet"),
          child: Text(AppLocalizations.of(context).translate('add_quote_list')),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, 50),
            ),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color(0XFF605c65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              builder: (context) => AddQuoteListBottomSheet(
                key: Key("add_quote_list_bottom_sheet"),
                getQuotesList: getQuotesList,
                scaffoldContext: scaffoldContext,
                addQuoteList: addQuoteList,
              ),
            );
          },
        ),
        TextButton(
          key: Key("open_add_quote_bottom_sheet"),
          child:
              Text(AppLocalizations.of(context).translate('add_quote_to_list')),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              Size(
                MediaQuery.of(context).size.width,
                50,
              ),
            ),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);

            if (list.isEmpty) {
              Scaffold.of(scaffoldContext).showSnackBar(
                SnackBar(
                  key: Key("empty_snackbar"),
                  content:
                      Text(AppLocalizations.of(context).translate('no_lists')),
                ),
              );
            } else {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Color(0XFF605c65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                builder: (context) => AddQuoteBottomSheet(
                  key: Key("add_quote_bottom_sheet"),
                  list: list,
                  getQuotesList: getQuotesList,
                  scaffoldContext: scaffoldContext,
                  addQuote: addQuote,
                ),
              );
            }
          },
        ),
        TextButton(
          child: Text("Cancel"),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, 50),
            ),
            backgroundColor: MaterialStateProperty.all(Color(0XFF56535a)),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
