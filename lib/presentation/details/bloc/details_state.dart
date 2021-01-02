import 'package:NeQuo/domain/entities/quote.dart';

abstract class DetailsState {}

class InitialState extends DetailsState {}

class LoadingState extends DetailsState {}

class SuccessState extends DetailsState {
  List<Quote> quotes;

  SuccessState({
    this.quotes,
  });
}

class EmptyState extends DetailsState {}

class ErrorState extends DetailsState {}
