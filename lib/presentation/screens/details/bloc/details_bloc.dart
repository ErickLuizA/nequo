import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/load_quote.dart';

import 'details_event.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  LoadQuote loadQuote;

  DetailsBloc({
    required this.loadQuote,
  }) : super(DetailsState(
          uiStatus: DetailsUIStatus.initial,
          quote: Quote.empty(),
        )) {
    on<GetQuoteEvent>(_onGetQuoteEvent);
  }

  void _onGetQuoteEvent(GetQuoteEvent event, Emitter<DetailsState> emit) async {
    emit(state.copyWith(uiStatus: DetailsUIStatus.loading));

    final result = await loadQuote(LoadQuoteParams(id: event.id));

    emit(result.fold(
      (failure) => state.copyWith(
        uiStatus: DetailsUIStatus.loading,
        error: 'error',
      ),
      (quote) => state.copyWith(
        uiStatus: DetailsUIStatus.loading,
        quote: quote,
        error: '',
      ),
    ));
  }
}
