import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/presentation/details/details_screen.dart';
import 'package:NeQuo/presentation/favorites/favorites_screen.dart';
import 'package:NeQuo/presentation/home/home_screen.dart';
import 'package:NeQuo/presentation/quote_of_the_day/quote_of_the_day_screen.dart';
import 'package:NeQuo/presentation/random_details/random_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeQuo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF6C63FF),
        indicatorColor: Color(0xFF7a72fe),
        canvasColor: Color(0xFF6C63FF),
        accentColor: Color(0xFF7a72fe),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 26,
        ),
        textTheme: TextTheme(
          bodyText1: GoogleFonts.flamenco(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          bodyText2: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: [
        LocalizationDelegate(isTest: false),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      initialRoute: '/',
      routes: {
        '/': (_) => QuoteOfTheDayScreen(),
        '/home': (_) => HomeScreen(),
        '/details': (_) => DetailsScreen(),
        '/random_details': (_) => RandomDetailsScreen(),
        '/favorites': (_) => FavoritesScreen(),
      },
    );
  }
}
