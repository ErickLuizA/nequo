import 'package:NeQuo/domain/usecases/load_random_quote.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';
import 'package:NeQuo/presentation/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:NeQuo/presentation/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class QuoteOfTheDayBloc extends Bloc<QuoteOfTheDayEvent, QuoteOfTheDayState> {
  final LoadRandomQuote loadRandomQuote;

  QuoteOfTheDayBloc({
    @required this.loadRandomQuote,
  }) : super(InitialState());

  @override
  Stream<QuoteOfTheDayState> mapEventToState(QuoteOfTheDayEvent event) async* {
    if (event is GetRandomQuote) {
      yield LoadingState();

      final result = await loadRandomQuote(NoParams());

      yield result.fold(
        (failure) => ErrorState(),
        (success) => SuccessState(quote: success),
      );
    }
  }
}
