import 'package:nequo/domain/repositories/categories_repository.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class DeleteCategoryParams {
  int id;

  DeleteCategoryParams({required this.id});
}

class DeleteCategory extends UseCase<void, DeleteCategoryParams> {
  CategoriesRepository categoriesRepository;

  DeleteCategory({
    required this.categoriesRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeleteCategoryParams params) async {
    return await categoriesRepository.delete(params);
  }
}
