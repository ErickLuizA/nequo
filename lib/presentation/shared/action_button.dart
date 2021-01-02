import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  final AlignmentGeometry align;

  const ActionButton({
    Key key,
    @required this.icon,
    @required this.onPress,
    this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align ?? Alignment.center,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Theme.of(context).indicatorColor,
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPress,
        ),
      ),
    );
  }
}
