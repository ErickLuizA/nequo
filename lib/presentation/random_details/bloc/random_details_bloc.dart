import 'package:NeQuo/domain/entities/quote.dart';
import 'package:NeQuo/domain/usecases/load_random_quotes.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_event.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomDetailsBloc extends Bloc<RandomDetailsEvent, RandomDetailsState> {
  LoadRandomQuotes loadRandomQuotes;

  RandomDetailsBloc({
    this.loadRandomQuotes,
  }) : super(InitialState());

  List<Quote> quotes = List<Quote>();

  @override
  Stream<RandomDetailsState> mapEventToState(RandomDetailsEvent event) async* {
    if (event is GetRandomQuotes) {
      yield LoadingState();

      final result = await loadRandomQuotes(event.params);

      yield result.fold(
        (failure) => ErrorState(),
        (success) {
          quotes.addAll(success);

          return SuccessState(quotes: quotes, scrollPos: event.scrollPos);
        },
      );
    }
  }
}
