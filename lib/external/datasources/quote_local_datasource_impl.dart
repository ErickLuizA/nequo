import 'package:nequo/data/datasources/quotes_local_datasource.dart';
import 'package:nequo/data/mappers/local/local_quote_mapper.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/update_quote.dart';
import 'package:nequo/external/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

const QUOTE_OF_THE_DAY = 'QUOTE_OF_THE_DAY';

class QuoteLocalDatasourceImpl implements QuotesLocalDatasource {
  final SharedPreferences sharedPreferences;
  final Database database;

  QuoteLocalDatasourceImpl({
    required this.sharedPreferences,
    required this.database,
  });

  @override
  Future<Quote> findQuoteOfTheDay() async {
    try {
      final quoteOfTheDayId = sharedPreferences.getInt(QUOTE_OF_THE_DAY);

      if (quoteOfTheDayId == null)
        throw CacheException(
          message: 'Quote of the day not found',
        );

      return await findOne(id: quoteOfTheDayId);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveQuoteOfTheDay({
    int? serverId,
    required AddQuoteParams params,
  }) async {
    try {
      final result = await database.query(
        QuotesTable,
        where: 'server_id = ?',
        whereArgs: [serverId],
      );

      if (result.isNotEmpty) return;

      final id = await database.insert(
        QuotesTable,
        LocalQuoteMapper.toMap(
          content: params.content,
          author: params.author,
          serverId: serverId,
        ),
      );

      await sharedPreferences.setInt(QUOTE_OF_THE_DAY, id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<Quote>> findAll() async {
    try {
      final result = await database.rawQuery(
        '''
        select quotes.*, 
        Favorites.id as favorite_id, 
        from Quotes 
        left join Favorites 
        on Quotes.id = Favorites.quote_id
        ''',
      );

      return result.map((e) => LocalQuoteMapper.toEntity(e)).toList();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<Quote> findOne({required int id}) async {
    try {
      final result = await database.rawQuery('''
        select quotes.*, 
        Favorites.id as favorite_id, 
        from Quotes 
        left join Favorites 
        on Quotes.id = Favorites.quote_id
        where Quotes.id = ?;
        ''', [id]);

      return LocalQuoteMapper.toEntity(result[0]);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<Quote> save({int? serverId, required AddQuoteParams params}) async {
    try {
      final result = await database.query(
        QuotesTable,
        where: 'server_id = ?',
        whereArgs: [serverId],
      );

      if (result.isNotEmpty) return LocalQuoteMapper.toEntity(result[0]);

      final id = await database.insert(
        QuotesTable,
        LocalQuoteMapper.toMap(
          content: params.content,
          author: params.author,
          serverId: serverId,
        ),
      );

      return findOne(id: id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<Quote> update(UpdateQuoteParams params) async {
    try {
      final id = await database.update(
        QuotesTable,
        LocalQuoteMapper.toMap(
          content: params.content,
          author: params.author,
        ),
      );

      return findOne(id: id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> delete(DeleteQuoteParams params) async {
    try {
      await database.delete(
        QuotesTable,
        where: 'id = ?',
        whereArgs: [params.id],
      );
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
