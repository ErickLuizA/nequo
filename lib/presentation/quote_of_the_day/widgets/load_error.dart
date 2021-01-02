import 'package:flutter/material.dart';

class LoadError extends StatelessWidget {
  final Function navigate;
  final Function retry;

  const LoadError({
    Key key,
    @required this.navigate,
    @required this.retry,
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
            "Error while loading quote of the day",
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
        SizedBox(height: 10),
        MaterialButton(
          child: Text('Continue'),
          minWidth: MediaQuery.of(context).size.width / 2,
          color: Theme.of(context).indicatorColor,
          textColor: Colors.white,
          onPressed: navigate,
        ),
      ],
    );
  }
}
