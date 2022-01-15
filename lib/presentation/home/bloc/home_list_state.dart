import 'package:nequo/domain/entities/quote_list.dart';

abstract class HomeListState {}

class InitialListState extends HomeListState {}

class LoadingListState extends HomeListState {}

class SuccessListState extends HomeListState {
  List<QuoteList> quoteList;

  SuccessListState({
    required this.quoteList,
  });
}

class EmptyListState extends HomeListState {}

class ErrorListState extends HomeListState {}
