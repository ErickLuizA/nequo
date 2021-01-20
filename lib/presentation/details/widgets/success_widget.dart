import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/presentation/details/widgets/delete_button.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/presentation/details/bloc/details_state.dart';
import 'package:NeQuo/presentation/details/widgets/favorite_button.dart';
import 'package:NeQuo/presentation/details/widgets/options_menu.dart';
import 'package:NeQuo/presentation/shared/widgets/action_button.dart';

class SuccessWidget extends StatefulWidget {
  final Function getQuotesList;
  final Function handleDeleteQuoteList;
  final SuccessState successState;
  final Function(String text) shareQuote;
  final Function(Favorite fav, int index) handleFavorite;
  final Function(DeleteQuoteParams params) handleDeleteQuote;
  final Function getQuotes;

  const SuccessWidget({
    Key key,
    @required this.getQuotesList,
    @required this.handleDeleteQuoteList,
    @required this.successState,
    @required this.shareQuote,
    @required this.handleFavorite,
    @required this.handleDeleteQuote,
    @required this.getQuotes,
  }) : super(key: key);

  @override
  _SuccessWidgetState createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            Text("${current + 1}/${widget.successState.quotes.length}"),
            OptionsMenu(
              getQuotesList: widget.getQuotesList,
              handleDeleteQuoteList: widget.handleDeleteQuoteList,
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PageView.builder(
              itemCount: widget.successState.quotes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final quote = widget.successState.quotes[index];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    current = index;
                  });
                });

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text(
                        quote.content,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "- ${quote.author}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionButton(
              icon: Icons.share_outlined,
              onPress: () {
                widget.shareQuote(widget.successState.quotes[current].content);
              },
            ),
            FavoriteButton(
              current: current,
              handleFavorite: widget.handleFavorite,
              state: widget.successState,
            ),
            DeleteButton(
              current: current,
              getQuotes: widget.getQuotes,
              handleDeleteQuote: widget.handleDeleteQuote,
              successState: widget.successState,
            ),
          ],
        ),
      ],
    );
  }
}
