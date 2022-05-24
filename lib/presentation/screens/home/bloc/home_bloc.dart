import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/usecase.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  LoadQuotes loadQuotes;

  HomeBloc({
    required this.loadQuotes,
  }) : super(HomeState(quotes: [], uiStatus: HomeUIStatus.initial)) {
    on<GetQuotesEvent>(_onGetQuotes);
  }

  _onGetQuotes(
    GetQuotesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(uiStatus: HomeUIStatus.loading));

    final result = await loadQuotes(NoParams());

    emit(
      result.fold(
        (failure) => state.copyWith(
          uiStatus: HomeUIStatus.error,
          error: failure.message,
        ),
        (success) {
          if (success.isEmpty) {
            return state.copyWith(uiStatus: HomeUIStatus.empty, error: '');
          } else {
            return state.copyWith(
              uiStatus: HomeUIStatus.success,
              error: '',
              quotes: success,
            );
          }
        },
      ),
    );
  }
}
