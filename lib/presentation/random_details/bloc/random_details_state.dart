import 'package:nequo/domain/entities/quote.dart';

abstract class RandomDetailsState {}

class InitialState extends RandomDetailsState {}

class LoadingState extends RandomDetailsState {}

class SuccessState extends RandomDetailsState {
  List<Quote> quotes;
  int scrollPos;

  SuccessState({
    required this.quotes,
    required this.scrollPos,
  });
}

class EmptyState extends RandomDetailsState {}

class ErrorState extends RandomDetailsState {}
