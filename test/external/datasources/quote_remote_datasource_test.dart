import 'package:nequo/data/models/quote_model.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/external/datasources/quote_remote_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../utils/random_json.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  QuoteRemoteDatasourceImpl quoteRemoteDatasourceImpl;
  MockHttpClient client;

  setUp(() {
    client = MockHttpClient();
    quoteRemoteDatasourceImpl = QuoteRemoteDatasourceImpl(client: client);
  });

  final params = LoadRandomQuotesParams(skip: 1);

  test('should return a quote when response code is 200', () async {
    when(client.get(any))
        .thenAnswer((_) async => http.Response(randomJsonResponse, 200));

    final result = await quoteRemoteDatasourceImpl.getRandom();

    expect(result, isA<Quote>());
  });

  test('should return a exception when response code is not 200', () async {
    when(client.get(any)).thenAnswer((_) async => http.Response('', 404));

    final call = quoteRemoteDatasourceImpl.getRandom;

    expect(() => call(), throwsA(isA<ServerException>()));
  });

  test('should return a list of quotes when response code is 200', () async {
    when(client.get(any))
        .thenAnswer((_) async => http.Response(quoteListJsonResponse, 200));

    final result = await quoteRemoteDatasourceImpl.getQuotes(params);

    expect(result, isA<List<Quote>>());
  });

  test('should return a exception when response code is not 200', () async {
    when(client.get(any)).thenAnswer((_) async => http.Response('', 404));

    final call = quoteRemoteDatasourceImpl.getQuotes;

    expect(() => call(params), throwsA(isA<ServerException>()));
  });
}
