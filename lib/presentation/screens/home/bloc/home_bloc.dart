import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  LoadQuotes loadQuotes;

  HomeBloc({
    required this.loadQuotes,
  }) : super(
          HomeState(
            quotes: [],
            uiStatus: HomeUIStatus.initial,
            page: 1,
            lastPage: 1,
          ),
        ) {
    on<GetQuotesEvent>(_onGetQuotes);
    on<GetNextQuotesEvent>(_onGetNextQuotes);
  }

  _onGetQuotes(
    GetQuotesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(uiStatus: HomeUIStatus.loading));

    final result = await loadQuotes(LoadQuotesParams());

    emit(
      result.fold(
        (failure) => state.copyWith(
          uiStatus: HomeUIStatus.error,
          error: failure.message,
        ),
        (success) {
          if (success.data.isEmpty) {
            return state.copyWith(uiStatus: HomeUIStatus.empty, error: '');
          } else {
            return state.copyWith(
              uiStatus: HomeUIStatus.success,
              error: '',
              quotes: success.data,
              page: success.currentPage,
              lastPage: success.lastPage,
            );
          }
        },
      ),
    );
  }

  _onGetNextQuotes(
    GetNextQuotesEvent event,
    Emitter<HomeState> emit,
  ) async {
    final result = await loadQuotes(
      LoadQuotesParams(page: event.page),
    );

    emit(
      result.fold(
        (failure) => state.copyWith(
          uiStatus: HomeUIStatus.paginationError,
          error: failure.message,
        ),
        (success) => state.copyWith(
          uiStatus: HomeUIStatus.success,
          error: '',
          quotes: state.quotes + success.data,
          page: success.currentPage,
          lastPage: success.lastPage,
        ),
      ),
    );
  }
}
