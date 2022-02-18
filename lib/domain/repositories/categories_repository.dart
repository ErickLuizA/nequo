import 'package:dartz/dartz.dart';

import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/domain/usecases/delete_category.dart';
import 'package:nequo/domain/usecases/update_category.dart';

class LoadCategoryParams {
  final int id;

  LoadCategoryParams({
    required this.id,
  });
}

abstract class CategoriesRepository {
  Future<Either<Failure, Category>> findOne(LoadCategoryParams params);

  Future<Either<Failure, List<Category>>> findAll();

  Future<Either<Failure, Category>> save(AddCategoryParams params);

  Future<Either<Failure, Category>> update(UpdateCategoryParams params);

  Future<Either<Failure, void>> delete(DeleteCategoryParams params);
}
