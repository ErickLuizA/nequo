import 'package:nequo/domain/entities/quote_list.dart';
import 'package:nequo/presentation/details/details_screen.dart';
import 'package:nequo/presentation/home/utils/random_id.dart';
import 'package:flutter/material.dart';

class QuoteListCard extends StatelessWidget {
  final int id;
  final String name;
  final Function? getQuotesList;

  const QuoteListCard({
    Key? key,
    required this.id,
    required this.name,
    this.getQuotesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      key: Key("quote_list_card"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        key: Key("list_tile"),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: () {
          id == ID
              ? Navigator.of(context).pushNamed('/random_details')
              : Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DetailsScreen(
                        quoteList: QuoteList(
                          id: id,
                          name: name,
                        ),
                        getQuotesList: () {
                          getQuotesList?.call();
                        },
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
