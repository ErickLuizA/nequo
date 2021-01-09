import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/presentation/details/details_screen.dart';
import 'package:NeQuo/presentation/home/utils/random_id.dart';
import 'package:flutter/material.dart';

class QuoteListCard extends StatelessWidget {
  final int id;
  final String name;
  final Function getQuotesList;

  const QuoteListCard({
    Key key,
    this.id,
    this.name,
    this.getQuotesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
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
                        getQuotesList: getQuotesList,
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
