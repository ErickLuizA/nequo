import 'package:nequo/domain/usecases/delete_quote_list.dart';
import 'package:nequo/presentation/details/bloc/delete_event.dart';
import 'package:nequo/presentation/details/bloc/delete_state.dart';
import 'package:bloc/bloc.dart';

import 'package:nequo/domain/usecases/delete_quote.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  DeleteQuote deleteQuote;
  DeleteQuoteList deleteQuoteList;

  DeleteBloc({
    required this.deleteQuote,
    required this.deleteQuoteList,
  }) : super(DeleteInitialState()) {
    on<DeleteQuoteEvent>(_onDeleteQuoteEvent);
    on<DeleteQuoteListEvent>(_onDeleteQuoteListEvent);
  }

  _onDeleteQuoteEvent(
    DeleteQuoteEvent event,
    Emitter<DeleteState> emit,
  ) async {
    emit(DeleteLoadingState());

    final result = await deleteQuote(event.params);

    emit(result.fold((l) => DeleteErrorState(), (r) => DeleteSuccessState()));
  }

  _onDeleteQuoteListEvent(
    DeleteQuoteListEvent event,
    Emitter<DeleteState> emit,
  ) async {
    emit(DeleteListLoadingState());

    final result = await deleteQuoteList(event.params);

    emit(result.fold(
      (l) => DeleteListErrorState(),
      (r) => DeleteListSuccessState(),
    ));
  }
}
