import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/shared/widgets/action_button.dart';
import 'package:NeQuo/presentation/shared/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

import 'package:NeQuo/presentation/random_details/bloc/random_details_state.dart';

class SuccessWidget extends StatefulWidget {
  final SuccessState state;
  final ShareQuote share;
  final Function(int skip, int scrollPos) getRandomQuotes;
  final Function(Favorite fav, int index) handleFavorite;

  const SuccessWidget({
    Key key,
    @required this.state,
    @required this.share,
    @required this.getRandomQuotes,
    @required this.handleFavorite,
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
            Text("${current + 1}/${widget.state.quotes.length}"),
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
              itemCount: widget.state.quotes.length,
              scrollDirection: Axis.horizontal,
              controller: PageController(
                initialPage: widget.state.scrollPos,
              ),
              itemBuilder: (context, index) {
                final quote = widget.state.quotes[index];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    current = index;
                  });
                });

                if (index == widget.state.quotes.length - 1) {
                  widget.getRandomQuotes(widget.state.quotes.length, index + 1);
                }

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
                widget.share(
                  ShareParams(
                    text: widget.state.quotes[current].content,
                    subject: 'NeQuo - Quotes app',
                  ),
                );
              },
            ),
            FavoriteButton(
              key: Key("favorite_button"),
              current: current,
              handleFavorite: widget.handleFavorite,
              state: widget.state,
            ),
          ],
        ),
      ],
    );
  }
}
