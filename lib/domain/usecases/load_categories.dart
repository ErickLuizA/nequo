import 'package:nequo/domain/entities/category.dart';
import 'package:dartz/dartz.dart';
import 'package:nequo/domain/errors/failures.dart';
import 'package:nequo/domain/repositories/categories_repository.dart';
import 'package:nequo/domain/usecases/usecase.dart';

class LoadCategories implements UseCase<List<Category>, NoParams> {
  CategoriesRepository categoriesRepository;

  LoadCategories({required this.categoriesRepository});

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await categoriesRepository.findAll();
  }
}
