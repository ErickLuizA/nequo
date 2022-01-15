import 'package:nequo/domain/entities/quote.dart';

abstract class DetailsState {}

class InitialState extends DetailsState {}

class LoadingState extends DetailsState {}

class SuccessState extends DetailsState {
  List<Quote> quotes;

  SuccessState({
    required this.quotes,
  });
}

class EmptyState extends DetailsState {}

class ErrorState extends DetailsState {}
