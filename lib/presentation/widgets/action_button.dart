import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPress;
  final AlignmentGeometry align;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.onPress,
    this.align = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Theme.of(context).colorScheme.surface,
        child: IconButton(
          color: Theme.of(context).colorScheme.onSurface,
          icon: Icon(icon),
          onPressed: onPress,
        ),
      ),
    );
  }
}
