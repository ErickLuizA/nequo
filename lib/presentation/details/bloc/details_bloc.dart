import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/presentation/details/bloc/details_event.dart';
import 'package:nequo/presentation/details/bloc/details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  LoadQuotes loadQuotes;

  DetailsBloc({
    required this.loadQuotes,
  }) : super(InitialState()) {
    on<GetQuotes>(_onGetQuotes);
  }

  void _onGetQuotes(GetQuotes event, Emitter<DetailsState> emit) async {
    emit(LoadingState());

    final result = await loadQuotes(event.params);

    emit(result.fold(
      (failure) => ErrorState(),
      (success) {
        if (success.isEmpty) {
          return EmptyState();
        } else {
          return SuccessState(quotes: success);
        }
      },
    ));
  }
}
