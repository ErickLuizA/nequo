import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Key("loading_widget_center"),
      child: CircularProgressIndicator(),
    );
  }
}
