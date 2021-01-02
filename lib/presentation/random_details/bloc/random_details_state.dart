import 'package:NeQuo/domain/entities/quote.dart';

abstract class RandomDetailsState {}

class InitialState extends RandomDetailsState {}

class LoadingState extends RandomDetailsState {}

class SuccessState extends RandomDetailsState {
  List<Quote> quotes;
  int scrollPos;

  SuccessState({
    this.quotes,
    this.scrollPos,
  });
}

class EmptyState extends RandomDetailsState {}

class ErrorState extends RandomDetailsState {}
