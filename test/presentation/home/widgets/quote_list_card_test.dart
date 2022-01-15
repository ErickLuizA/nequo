import 'package:nequo/app_localizations.dart';
import 'package:nequo/presentation/home/widgets/quote_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nequo/service_locator.dart' as sl;

void getQuoteList() {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final mockObserver = MockNavigatorObserver();

  setUp(() async {
    await sl.setUp(testing: true);
  });

  tearDown(() async {
    await sl.getIt.reset();
  });

  testWidgets('render widget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: Scaffold(
          body: QuoteListCard(
            id: 1,
            getQuotesList: getQuoteList,
            name: 'name',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(Key("quote_list_card")), findsOneWidget);
  });

  testWidgets('should show text passed in constructor', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockObserver],
        home: Scaffold(
          body: QuoteListCard(
            id: 1,
            getQuotesList: getQuoteList,
            name: 'name',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('name'), findsOneWidget);
  });

  testWidgets('should navigate when list tile is pressed', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('pt', 'BR'),
        ],
        localizationsDelegates: [
          LocalizationDelegate(isTest: true),
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
        navigatorObservers: [mockObserver],
        home: Scaffold(
          body: QuoteListCard(
            id: 1,
            getQuotesList: getQuoteList,
            name: 'name',
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(Key("list_tile")));
    await tester.pump();

    verify(mockObserver.didPush(any, any));
  });
}
