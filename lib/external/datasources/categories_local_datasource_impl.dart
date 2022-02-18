import 'package:nequo/data/mappers/local/local_category_mapper.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/external/services/database.dart';
import 'package:sqflite/sqflite.dart';

import 'package:nequo/data/datasources/categories_local_datasource.dart';
import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/domain/usecases/delete_category.dart';
import 'package:nequo/domain/usecases/update_category.dart';

class CategoriesLocalDatasourceImpl extends CategoriesLocalDatasource {
  final Database database;

  CategoriesLocalDatasourceImpl({required this.database});

  @override
  Future<List<Category>> findAll() async {
    try {
      final result = await database.query(CategoriesTable);

      return result.map((e) => LocalCategoryMapper.toEntity(e)!).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Category> findOne({required int id}) async {
    try {
      final result = await database.query(
        CategoriesTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) throw CacheException();

      return LocalCategoryMapper.toEntity(result[0])!;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Category> save(AddCategoryParams params) async {
    try {
      final result = await database.query(
        CategoriesTable,
        where: 'name = ?',
        whereArgs: [params.name],
      );

      if (result.isNotEmpty) return LocalCategoryMapper.toEntity(result[0])!;

      final id = await database.insert(
        CategoriesTable,
        LocalCategoryMapper.toMap(name: params.name),
      );

      return findOne(id: id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Category> update(UpdateCategoryParams params) async {
    try {
      final id = await database.update(
        CategoriesTable,
        LocalCategoryMapper.toMap(name: params.name),
      );

      return findOne(id: id);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> delete(DeleteCategoryParams params) async {
    try {
      await database.delete(
        CategoriesTable,
        where: 'id = ?',
        whereArgs: [params.id],
      );
    } catch (e) {
      throw CacheException();
    }
  }
}
