import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_event.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomDetailsBloc extends Bloc<RandomDetailsEvent, RandomDetailsState> {
  LoadRandomQuotes loadRandomQuotes;

  RandomDetailsBloc({
    required this.loadRandomQuotes,
  }) : super(InitialState()) {
    on<GetRandomQuotes>(_onGetRandomQuote);
  }

  List<Quote> quotes = [];

  void _onGetRandomQuote(
    GetRandomQuotes event,
    Emitter<RandomDetailsState> emit,
  ) async {
    emit(LoadingState());

    final result = await loadRandomQuotes(event.params);

    result.fold(
      (failure) => emit(ErrorState()),
      (success) {
        quotes.addAll(success);

        emit(SuccessState(quotes: quotes, scrollPos: event.scrollPos));
      },
    );
  }
}
