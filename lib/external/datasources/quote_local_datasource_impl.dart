import 'dart:convert';
import 'package:NeQuo/data/datasources/quote_local_datasource.dart';
import 'package:NeQuo/data/models/quote_list_model.dart';
import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/domain/errors/exceptions.dart';
import 'package:NeQuo/data/models/quote_model.dart';
import 'package:NeQuo/domain/usecases/add_quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote_list.dart';
import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/domain/usecases/load_quotes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

const CACHE_QUOTE = 'CACHE_QUOTE';

class QuoteLocalDatasourceImpl implements QuoteLocalDatasource {
  final SharedPreferences sharedPreferences;
  final Database database;

  QuoteLocalDatasourceImpl({
    @required this.sharedPreferences,
    @required this.database,
  });

  @override
  Future<void> cacheQuote(QuoteModel quoteModel) {
    return sharedPreferences.setString(
        CACHE_QUOTE, jsonEncode(quoteModel.toMap()));
  }

  @override
  Future<QuoteModel> getLastQuote() {
    final jsonString = sharedPreferences.getString(CACHE_QUOTE);

    if (jsonString != null) {
      return Future.value(QuoteModel.fromMap(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<QuoteListModel>> getCachedQuoteList() async {
    try {
      final result = await database.query('QuoteList');

      return List.generate(result.length, (i) {
        return QuoteListModel.fromMap(result[i]);
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<QuoteModel>> getCachedQuotes(LoadQuotesParams params) async {
    try {
      final result = await database
          .query('Quotes', where: 'listId = ?', whereArgs: [params.id]);

      return List.generate(result.length, (i) {
        return QuoteModel.fromMap(result[i]);
      });
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addQuoteList(QuoteList params) async {
    try {
      await database.insert(
        'QuoteList',
        QuoteListModel(name: params.name).toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addQuote(AddQuoteParams params) async {
    try {
      await database.insert(
        'Quotes',
        QuoteModel(
          listId: params.listId,
          content: params.content,
          author: params.author,
        ).toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteQuote(DeleteQuoteParams params) async {
    try {
      await database.delete(
        'Quotes',
        where: "id = ?",
        whereArgs: [params.id],
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteQuoteList(DeleteQuoteListParams params) async {
    try {
      await database.delete(
        'QuoteList',
        where: "id = ?",
        whereArgs: [params.id],
      );
    } catch (e) {
      throw CacheException();
    }
  }
}
