import 'package:NeQuo/domain/usecases/load_quotes.dart';
import 'package:NeQuo/presentation/details/bloc/details_event.dart';
import 'package:NeQuo/presentation/details/bloc/details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  LoadQuotes loadQuotes;

  DetailsBloc({
    this.loadQuotes,
  }) : super(InitialState());

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    if (event is GetQuotes) {
      yield LoadingState();

      final result = await loadQuotes(event.params);

      yield result.fold(
        (failure) => ErrorState(),
        (success) {
          if (success.isEmpty) {
            return EmptyState();
          } else {
            return SuccessState(quotes: success);
          }
        },
      );
    }
  }
}
