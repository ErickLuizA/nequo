import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String text;
  final String? buttonText;
  final void Function()? onPressed;

  EmptyList({
    Key? key,
    required this.text,
    this.onPressed,
    this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_box_outline_blank,
            size: 50,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          SizedBox(height: 10),
          if (buttonText != null && onPressed != null)
            TextButton(
              onPressed: onPressed,
              child: Text(buttonText!),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
        ],
      ),
    );
  }
}
