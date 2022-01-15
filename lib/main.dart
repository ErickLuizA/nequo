import 'package:nequo/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:nequo/service_locator.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await sl.setUp();

  runApp(App());
}
