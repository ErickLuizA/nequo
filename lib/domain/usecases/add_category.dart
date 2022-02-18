import 'package:dartz/dartz.dart';

import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/categories_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class AddCategoryParams {
  final String name;

  AddCategoryParams({required this.name});
}

class AddCategory implements UseCase<void, AddCategoryParams> {
  CategoriesRepository categoriesRepository;

  AddCategory({
    required this.categoriesRepository,
  });

  @override
  Future<Either<Failure, Category>> call(AddCategoryParams params) async {
    return await categoriesRepository.save(params);
  }
}
