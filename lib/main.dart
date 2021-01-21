import 'package:NeQuo/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:NeQuo/service_locator.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await sl.setUp(testing: false);

  runApp(App());
}
