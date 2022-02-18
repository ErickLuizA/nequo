import 'package:dartz/dartz.dart';
import 'package:nequo/domain/entities/category.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/categories_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class UpdateCategoryParams {
  final String name;

  UpdateCategoryParams({required this.name});
}

class UpdateCategory extends UseCase<Category, UpdateCategoryParams> {
  final CategoriesRepository categoriesRepository;

  UpdateCategory({required this.categoriesRepository});

  @override
  Future<Either<Failure, Category>> call(UpdateCategoryParams params) async {
    return await categoriesRepository.update(params);
  }
}
