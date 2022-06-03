import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nequo/data/datasources/quotes_remote_datasource.dart';
import 'package:nequo/data/mappers/local/remote_quote_mapper.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/usecase.dart';

final baseUrl = DotEnv().env['API_BASE_URL'] ?? '';

class QuoteRemoteDatasourceImpl implements QuotesRemoteDatasource {
  final http.Client client;

  QuoteRemoteDatasourceImpl({
    required this.client,
  });

  @override
  Future<Quote> findQuoteOfTheDay() async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl + '/quotes/quote_of_the_day'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return RemoteQuoteOfTheDayMapper.toEntity(data);
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaginatedResponse<List<Quote>>> findAll(
      LoadQuotesParams params) async {
    try {
      final response = await client.get(Uri.parse(
        baseUrl + "/quotes?page=${params.page}&per_page=${params.perPage}",
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return RemoteQuoteMapper.toPaginatedQuoteList(data);
      } else {
        throw ServerException(message: response.body);
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Quote> findRandom() async {
    try {
      final response = await client.get(Uri.parse(baseUrl + '/quotes/random'));

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

  @override
  Future<Quote> findOne({required int id}) async {
    try {
      final response = await client.get(Uri.parse(baseUrl + '/quotes/$id'));

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
