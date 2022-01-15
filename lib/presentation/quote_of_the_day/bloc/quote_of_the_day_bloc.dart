import 'package:nequo/domain/usecases/load_random_quote.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:bloc/bloc.dart';

class QuoteOfTheDayBloc extends Bloc<QuoteOfTheDayEvent, QuoteOfTheDayState> {
  final LoadRandomQuote loadRandomQuote;

  QuoteOfTheDayBloc({
    required this.loadRandomQuote,
  }) : super(InitialState()) {
    on<GetRandomQuote>(_onGetRandomQuote);
  }

  void _onGetRandomQuote(
    GetRandomQuote event,
    Emitter<QuoteOfTheDayState> emit,
  ) async {
    emit(LoadingState());

    final result = await loadRandomQuote(NoParams());

    emit(result.fold(
      (failure) => ErrorState(),
      (success) => SuccessState(quote: success),
    ));
  }
}
