import 'package:dartz/dartz.dart';

import 'package:nequo/data/datasources/categories_local_datasource.dart';
import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/exceptions.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/categories_repository.dart';
import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/domain/usecases/delete_category.dart';
import 'package:nequo/domain/usecases/update_category.dart';

class CategoriesRepositoryImpl extends CategoriesRepository {
  final CategoriesLocalDatasource categoriesLocalDatasource;

  CategoriesRepositoryImpl({
    required this.categoriesLocalDatasource,
  });

  @override
  Future<Either<Failure, List<Category>>> findAll() async {
    try {
      final result = await categoriesLocalDatasource.findAll();

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> findOne(LoadCategoryParams params) async {
    try {
      final result = await categoriesLocalDatasource.findOne(id: params.id);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> save(AddCategoryParams params) async {
    try {
      final result = await categoriesLocalDatasource.save(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> update(UpdateCategoryParams params) async {
    try {
      final result = await categoriesLocalDatasource.update(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> delete(DeleteCategoryParams params) async {
    try {
      final result = await categoriesLocalDatasource.delete(params);

      return Right(result);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
