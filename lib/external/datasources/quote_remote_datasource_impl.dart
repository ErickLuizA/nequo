import 'package:nequo/data/datasources/quotes_remote_datasource.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:http/http.dart' as http;

class QuoteRemoteDatasourceImpl implements QuotesRemoteDatasource {
  final http.Client client;

  QuoteRemoteDatasourceImpl({
    required this.client,
  });

  @override
  Future<Quote> findQuoteOfTheDay() async {
    try {
      return Quote(
        id: 1,
        author: 'Author',
        content:
            "Many of life's failures are people who did not realize how close they were to success when they gave up.",
        isFavorited: false,
      );
    } catch (e) {
      throw ServerException();
    }
  }

  // @override
  // Future<Quote> getRandom() async {
  //   return Quote(
  //     id: 1,
  //     author: 'Author',
  //     content:
  //         "Many of life's failures are people who did not realize how close they were to success when they gave up.",
  //     isFavorited: false,
  //   );

  //   // if (response.statusCode == 200) {
  //   //   return Quote.fromJson(response.body).toEntity();
  //   // } else {
  //   //   throw ServerException();
  //   // }
  // }

  // @override
  // Future<List<Quote>> getQuotes(LoadRandomQuotesParams params) async {
  //   return [
  //     Quote(
  //         id: 1,
  //         author: 'Author',
  //         content:
  //             "Many of life's failures are people who did not realize how close they were to success when they gave up.",
  //         isFavorited: false),
  //     Quote(
  //         id: 2,
  //         author: 'Author 2',
  //         content:
  //             "Don’t settle for what life gives you; make life better and build something.",
  //         isFavorited: false),
  //   ];

  //   // final response = await this
  //   //     .client
  //   //     .get(Uri.parse('http://api.quotable.io/quotes?skip=${params.skip}'));

  //   // if (response.statusCode == 200) {
  //   //   final data = jsonDecode(response.body);

  //   //   final Iterable list = data['results'];

  //   //   return list.map((item) => Quote.fromMap(item).toEntity()).toList();
  //   // } else {
  //   //   throw ServerException();
  //   // }
  // }
}
