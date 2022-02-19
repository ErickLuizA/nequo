import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure({
    required this.message,
  });

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  ServerFailure({String? message}) : super(message: message ?? '');
}

class CacheFailure extends Failure {
  CacheFailure({String? message}) : super(message: message ?? '');
}
