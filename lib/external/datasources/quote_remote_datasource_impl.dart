import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nequo/data/datasources/quotes_remote_datasource.dart';
import 'package:nequo/data/mappers/local/remote_quote_mapper.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';

const BASE_URL = 'http://192.168.0.105:3333/api/v1';

class QuoteRemoteDatasourceImpl implements QuotesRemoteDatasource {
  final http.Client client;

  QuoteRemoteDatasourceImpl({
    required this.client,
  });

  @override
  Future<Quote> findQuoteOfTheDay() async {
    try {
      final response = await client.get(
        Uri.parse(BASE_URL + '/quotes/quote_of_the_day'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return RemoteQuoteMapper.toEntity(data);
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
