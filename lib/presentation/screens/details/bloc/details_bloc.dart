import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/load_quote.dart';
import 'package:nequo/domain/usecases/load_random_quote.dart';
import 'package:nequo/domain/usecases/usecase.dart';

import 'details_event.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  LoadQuote loadQuote;
  LoadRandomQuote loadRandomQuote;
  final AddFavorite addFavorite;
  final DeleteFavorite deleteFavorite;

  DetailsBloc({
    required this.loadQuote,
    required this.loadRandomQuote,
    required this.addFavorite,
    required this.deleteFavorite,
  }) : super(DetailsState(
          uiStatus: DetailsUIStatus.initial,
          quote: Quote.empty(),
        )) {
    on<GetQuoteEvent>(_onGetQuoteEvent);
    on<AddToFavorites>(_onAddToFavorites);
    on<DeleteFromFavorites>(_onDeleteFromFavorites);
  }

  void _onGetQuoteEvent(GetQuoteEvent event, Emitter<DetailsState> emit) async {
    emit(state.copyWith(uiStatus: DetailsUIStatus.loading));

    final result = event.id != null
        ? await loadQuote(LoadQuoteParams(id: event.id!))
        : await loadRandomQuote(NoParams());

    emit(
      result.fold(
        (failure) => state.copyWith(
          uiStatus: DetailsUIStatus.error,
          error: failure.message,
        ),
        (quote) => state.copyWith(
          uiStatus: DetailsUIStatus.success,
          quote: quote,
          error: '',
        ),
      ),
    );
  }

  void _onAddToFavorites(
    AddToFavorites event,
    Emitter<DetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        quote: state.quote.copyWith(isFavorited: true),
      ),
    );

    final result = await addFavorite(AddFavoriteParams(quote: event.quote));

    if (result.isLeft()) {
      emit(state.copyWith(
        quote: state.quote.copyWith(isFavorited: false),
        actionStatus: DetailsActionStatus.favoriteError,
      ));
    }
  }

  void _onDeleteFromFavorites(
    DeleteFromFavorites event,
    Emitter<DetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        quote: state.quote.copyWith(isFavorited: false),
      ),
    );

    final result = await deleteFavorite(
      DeleteFavoriteParams(id: event.quoteId),
    );

    if (result.isLeft()) {
      emit(state.copyWith(
        quote: state.quote.copyWith(isFavorited: true),
        actionStatus: DetailsActionStatus.unfavoriteError,
      ));
    }
  }
}
