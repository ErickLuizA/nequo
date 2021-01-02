import 'package:NeQuo/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:NeQuo/dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.setUp();

  runApp(App());
}
