import 'package:nequo/domain/usecases/load_quotes_list.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:nequo/presentation/home/bloc/home_list_event.dart';
import 'package:nequo/presentation/home/bloc/home_list_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeListBloc extends Bloc<HomeListEvent, HomeListState> {
  LoadQuotesList loadQuotesList;

  HomeListBloc({
    required this.loadQuotesList,
  }) : super(InitialListState()) {
    on<GetQuotesList>(_onGetQuotesList);
  }

  _onGetQuotesList(
    GetQuotesList event,
    Emitter<HomeListState> emit,
  ) async {
    emit(LoadingListState());
    final result = await loadQuotesList(NoParams());

    emit(result.fold(
      (failure) => ErrorListState(),
      (success) {
        if (success.isEmpty) {
          return EmptyListState();
        } else {
          return SuccessListState(quoteList: success);
        }
      },
    ));
  }
}
