import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nequo/domain/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class Usecase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class PaginatedResponse<Type> extends Equatable {
  final int? total;
  final int perPage;
  final int currentPage;
  final int? firstPage;
  final int? lastPage;
  final Type data;

  PaginatedResponse({
    this.total,
    this.firstPage,
    this.lastPage,
    required this.perPage,
    required this.currentPage,
    required this.data,
  });

  @override
  List<Object?> get props => [
        total,
        perPage,
        firstPage,
        currentPage,
        lastPage,
        data,
      ];
}
