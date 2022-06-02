import 'package:nequo/data/datasources/quotes_local_datasource.dart';
import 'package:nequo/data/mappers/local/local_quote_mapper.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/external/services/database/database.dart';
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

      if (quoteOfTheDayId == null) {
        throw CacheException(message: 'Quote of the day not found');
      }

      return await findOne(id: quoteOfTheDayId);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveQuoteOfTheDay({
    required AddQuoteParams params,
  }) async {
    try {
      final result = await database.query(
        QuotesTable,
        where: 'id = ?',
        whereArgs: [params.id],
      );

      if (result.isNotEmpty) return;

      final id = await database.insert(
        QuotesTable,
        LocalQuoteMapper.toMap(
          id: params.id,
          content: params.content,
          author: params.author,
          authorSlug: params.authorSlug,
        ),
      );

      await sharedPreferences.setInt(QUOTE_OF_THE_DAY, id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<Quote>> findAll({required bool isFeed}) async {
    try {
      final result = await database.rawQuery(
        '''
        select quotes.*, 
        Favorites.id as favorite_id
        from Quotes 
        left join Favorites 
        on Quotes.id = Favorites.quote_id
        ''' +
            (isFeed ? 'where Quotes.is_feed = ?' : ''),
        [isFeed ? 1 : 0],
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
        Favorites.id as favorite_id
        from Quotes 
        left join Favorites 
        on Quotes.id = Favorites.quote_id
        where Quotes.id = ?;
        ''', [id]);

      if (result.isEmpty) throw CacheException(message: 'Quote not found');

      return LocalQuoteMapper.toEntity(result[0]);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<Quote> save({required AddQuoteParams params}) async {
    try {
      final id = await database.insert(
        QuotesTable,
        LocalQuoteMapper.toMap(
          id: params.id,
          content: params.content,
          author: params.author,
          authorSlug: params.authorSlug,
        ),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return findOne(id: id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<Quote>> saveAll({
    required List<SaveQuoteParams> params,
    bool replace = true,
  }) async {
    try {
      await database.transaction((txn) async {
        final batch = txn.batch();

        if (replace) {
          batch.delete(QuotesTable, where: 'is_feed = ?', whereArgs: [1]);
        }

        params.forEach((element) {
          batch.insert(
            QuotesTable,
            LocalQuoteMapper.toMap(
              id: element.params.id,
              content: element.params.content,
              author: element.params.author,
              authorSlug: element.params.authorSlug,
              isFeed: true,
            ),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        });

        await batch.commit();
      });

      return await findAll(isFeed: true);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<Quote> findRandom() async {
    try {
      final result = await database.rawQuery('''
        select quotes.*, 
        Favorites.id as favorite_id
        from Quotes 
        left join Favorites 
        on Quotes.id = Favorites.quote_id
        order by random()
        limit 1
        ''');

      if (result.isEmpty) throw CacheException(message: 'Quote not found');

      return LocalQuoteMapper.toEntity(result[0]);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
