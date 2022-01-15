import 'package:flutter/material.dart';

import 'package:nequo/presentation/favorites/bloc/favorites_state.dart';
import 'package:nequo/presentation/shared/widgets/action_button.dart';

class SuccessWidget extends StatefulWidget {
  final SuccessState state;
  final Function(String text) shareQuote;
  final Function(int id) deleteFavorite;

  const SuccessWidget({
    Key? key,
    required this.state,
    required this.shareQuote,
    required this.deleteFavorite,
  }) : super(key: key);

  @override
  _SuccessWidgetState createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key("success_widget_column"),
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
            Text("${current + 1}/${widget.state.favorites.length}"),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PageView.builder(
              itemCount: widget.state.favorites.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final quote = widget.state.favorites[index];

                WidgetsBinding.instance?.addPostFrameCallback((_) {
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
              key: Key("share_action_button"),
              icon: Icons.share_outlined,
              onPress: () {
                widget.shareQuote(widget.state.favorites[current].content);
              },
            ),
            ActionButton(
              key: Key("delete_action_button"),
              icon: Icons.delete_outline,
              onPress: () {
                widget.deleteFavorite(widget.state.favorites[current].id!);
              },
            ),
          ],
        ),
      ],
    );
  }
}
