import 'package:flutter/material.dart';

class LoadErrorWidget extends StatelessWidget {
  final String text;
  final Function retry;

  const LoadErrorWidget({
    Key key,
    this.text,
    this.retry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning,
          color: Colors.orange[700],
          size: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        MaterialButton(
          child: Text('Try again'),
          minWidth: MediaQuery.of(context).size.width / 2,
          color: Theme.of(context).indicatorColor,
          textColor: Colors.white,
          onPressed: retry,
        ),
      ],
    );
  }
}
