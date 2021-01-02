import 'package:NeQuo/domain/usecases/delete_quote_list.dart';
import 'package:NeQuo/presentation/details/bloc/delete_event.dart';
import 'package:NeQuo/presentation/details/bloc/delete_state.dart';
import 'package:bloc/bloc.dart';

import 'package:NeQuo/domain/usecases/delete_quote.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  DeleteQuote deleteQuote;
  DeleteQuoteList deleteQuoteList;

  DeleteBloc({
    this.deleteQuote,
    this.deleteQuoteList,
  }) : super(DeleteInitialState());

  @override
  Stream<DeleteState> mapEventToState(DeleteEvent event) async* {
    if (event is DeleteQuoteEvent) {
      yield DeleteLoadingState();

      final result = await deleteQuote(event.params);

      yield result.fold((l) => DeleteErrorState(), (r) => DeleteSuccessState());
    } else if (event is DeleteQuoteListEvent) {
      yield DeleteListLoadingState();

      final result = await deleteQuoteList(event.params);

      yield result.fold(
        (l) => DeleteListErrorState(),
        (r) => DeleteListSuccessState(),
      );
    }
  }
}
