import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/quote_of_the_day_screen.dart';
import 'package:nequo/service_locator.dart';

import 'presentation/screens/details/bloc/details_bloc.dart';
import 'presentation/screens/details/details_screen.dart';
import 'presentation/screens/favorites/bloc/favorites_bloc.dart';
import 'presentation/screens/favorites/favorites_screen.dart';
import 'presentation/screens/home/bloc/home_bloc.dart';
import 'presentation/screens/home/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [],
      child: MaterialApp(
        title: 'nequo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple[400],
          indicatorColor: Colors.deepPurple[300],
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
        initialRoute: '/quote_of_the_day',
        onGenerateRoute: (routeSettings) {
          final name = routeSettings.name;
          final args = routeSettings.arguments;

          if (name == '/quote_of_the_day') {
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => getIt<QuoteOfTheDayBloc>(),
                child: QuoteOfTheDayScreen(
                  shareQuote: getIt<ShareQuote>(),
                ),
              ),
            );
          }

          if (name == '/home') {
            return MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (_) => getIt<HomeBloc>(),
                  child: HomeScreen(
                    addCategory: getIt(),
                    addQuote: getIt(),
                    homeBloc: getIt(),
                    share: getIt(),
                  ),
                );
              },
            );
          }

          if (name == '/details') {
            return MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (_) => getIt<DetailsBloc>(),
                  child: DetailsScreen(
                    detailsBloc: getIt(),
                    share: getIt(),
                  ),
                );
              },
            );
          }

          if (name == '/favorites') {
            return MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (_) => getIt<FavoritesBloc>(),
                  child: FavoritesScreen(
                    share: getIt(),
                    favoritesBloc: getIt(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
