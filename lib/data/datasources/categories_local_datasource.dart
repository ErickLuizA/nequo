import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/domain/usecases/delete_category.dart';
import 'package:nequo/domain/usecases/update_category.dart';

abstract class CategoriesLocalDatasource {
  Future<Category> findOne({required int id});

  Future<List<Category>> findAll();

  Future<Category> save(AddCategoryParams params);

  Future<Category> update(UpdateCategoryParams params);

  Future<void> delete(DeleteCategoryParams params);
}
