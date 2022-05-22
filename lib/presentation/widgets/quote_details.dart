import 'package:flutter/material.dart';
import 'package:nequo/domain/entities/quote.dart';

class QuoteDetails extends StatelessWidget {
  final Quote quote;

  const QuoteDetails({
    Key? key,
    required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.format_quote,
                      size: 30,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    quote.content,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 10),
                  Icon(
                    Icons.format_quote,
                    size: 30,
                    color: Theme.of(context).colorScheme.onBackground,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '-${quote.author}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
