import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/presentation/home/widgets/add_quote_bottom_sheet.dart';
import 'package:NeQuo/presentation/home/widgets/add_quote_list_bottom_sheet.dart';

class BottomSheetWidget extends StatelessWidget {
  final List<QuoteList> list;
  final BuildContext scaffoldContext;
  final Function getQuotesList;

  const BottomSheetWidget({
    Key key,
    this.list,
    this.scaffoldContext,
    this.getQuotesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 15,
      children: [
        TextButton(
          child: Text("Add quote list"),
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
                getQuotesList: getQuotesList,
                scaffoldContext: scaffoldContext,
              ),
            );
          },
        ),
        TextButton(
          child: Text("Add quote to list"),
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
                  content: Text("You don't have created lists to add quotes."),
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
                  list: list,
                  getQuotesList: getQuotesList,
                  scaffoldContext: scaffoldContext,
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
