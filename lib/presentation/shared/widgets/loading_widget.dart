import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Key key;

  LoadingWidget(this.key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
