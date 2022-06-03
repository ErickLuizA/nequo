import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nequo/app_widget.dart';
import 'package:nequo/service_locator.dart' as sl;

void main() async {
  const bool isProduction = bool.fromEnvironment('dart.vm.product');

  if (isProduction) {
    await dotenv.load(fileName: '.env');
  } else {
    await dotenv.load(fileName: '.env.local');
  }

  WidgetsFlutterBinding.ensureInitialized();

  await sl.setUp();

  runApp(App());
}
