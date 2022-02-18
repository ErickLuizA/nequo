import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:flutter/material.dart';

import 'package:nequo/presentation/widgets/action_button.dart';

import 'options_menu.dart';

class SuccessWidget extends StatefulWidget {
  final Function getCategories;
  final Function handleDeleteCategory;
  final Quote successState;
  final Function(String text) shareQuote;
  final Function(Quote fav, int index) handleFavorite;
  final Function(DeleteQuoteParams params) handleDeleteQuote;
  final Function getQuotes;

  const SuccessWidget({
    Key? key,
    required this.getCategories,
    required this.handleDeleteCategory,
    required this.successState,
    required this.shareQuote,
    required this.handleFavorite,
    required this.handleDeleteQuote,
    required this.getQuotes,
  }) : super(key: key);

  @override
  _SuccessWidgetState createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Text('hello world');
    // return Column(
    //   key: Key("success_widget_column"),
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         IconButton(
    //           icon: Icon(Icons.arrow_back_ios),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //         ),
    //         Text("${current + 1}/${widget.successState.quotes.length}"),
    //         OptionsMenu(
    //           getCategories: widget.getCategories,
    //           handleDeleteCategory: widget.handleDeleteCategory,
    //         ),
    //       ],
    //     ),
    //     SizedBox(
    //       height: MediaQuery.of(context).size.height / 2,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 15),
    //         child: PageView.builder(
    //           itemCount: widget.successState.quotes.length,
    //           scrollDirection: Axis.horizontal,
    //           itemBuilder: (context, index) {
    //             final quote = widget.successState.quotes[index];

    //             WidgetsBinding.instance?.addPostFrameCallback((_) {
    //               setState(() {
    //                 current = index;
    //               });
    //             });

    //             return SizedBox(
    //               width: MediaQuery.of(context).size.width,
    //               child: Column(
    //                 children: [
    //                   Text(
    //                     quote.content,
    //                     style: Theme.of(context).textTheme.bodyText1,
    //                   ),
    //                   SizedBox(height: 20),
    //                   Align(
    //                     alignment: Alignment.centerRight,
    //                     child: Text(
    //                       "- ${quote.author}",
    //                       style: Theme.of(context).textTheme.bodyText1,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         ActionButton(
    //           key: Key("share_button"),
    //           icon: Icons.share_outlined,
    //           onPress: () {
    //             widget.shareQuote(widget.successState.quotes[current].content);
    //           },
    //         ),
    //         FavoriteButton(
    //           current: current,
    //           handleFavorite: widget.handleFavorite,
    //           state: widget.successState,
    //         ),
    //         DeleteButton(
    //           current: current,
    //           getQuotes: widget.getQuotes,
    //           handleDeleteQuote: widget.handleDeleteQuote,
    //           successState: widget.successState,
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}
