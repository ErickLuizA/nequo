import 'dart:convert';

import 'package:nequo/data/datasources/quote_remote_datasource.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/data/models/quote_model.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';
import 'package:http/http.dart' as http;

class QuoteRemoteDatasourceImpl implements QuoteRemoteDatasource {
  final http.Client client;

  QuoteRemoteDatasourceImpl({
    required this.client,
  });

  @override
  Future<QuoteModel> getRandom() async {
    final response =
        await this.client.get(Uri.parse('http://api.quotable.io/random'));

    if (response.statusCode == 200) {
      return QuoteModel.fromMap(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<QuoteModel>> getQuotes(LoadRandomQuotesParams params) async {
    final response = await this
        .client
        .get(Uri.parse('http://api.quotable.io/quotes?skip=${params.skip}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final Iterable list = data['results'];

      return list.map((item) => QuoteModel.fromMap(item)).toList();
    } else {
      throw ServerException();
    }
  }
}
