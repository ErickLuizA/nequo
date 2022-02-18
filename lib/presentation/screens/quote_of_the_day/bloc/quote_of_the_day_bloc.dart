import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/load_quote_of_the_day.dart';
import 'package:nequo/domain/usecases/usecase.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_event.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_state.dart';
import 'package:bloc/bloc.dart';

class QuoteOfTheDayBloc extends Bloc<QuoteOfTheDayEvent, QuoteOfTheDayState> {
  final LoadQuoteOfTheDay loadQuoteOfTheDay;
  final AddFavorite addFavorite;
  final DeleteFavorite deleteFavorite;

  QuoteOfTheDayBloc({
    required this.loadQuoteOfTheDay,
    required this.addFavorite,
    required this.deleteFavorite,
  }) : super(QuoteOfTheDayState(uiStatus: QuoteOfTheDayUIStatus.initial)) {
    on<GetQuoteOfTheDay>(_onGetQuoteOfTheDay);
    on<AddToFavorites>(_onAddToFavorites);
    on<DeleteFromFavorites>(_onDeleteFromFavorites);
  }

  void _onGetQuoteOfTheDay(
    GetQuoteOfTheDay event,
    Emitter<QuoteOfTheDayState> emit,
  ) async {
    emit(state.copyWith(uiStatus: QuoteOfTheDayUIStatus.loading));

    final result = await loadQuoteOfTheDay(NoParams());

    emit(
      result.fold(
        (failure) => state.copyWith(
          error: 'unknow error',
          uiStatus: QuoteOfTheDayUIStatus.error,
        ),
        (quote) => state.copyWith(
          quote: quote,
          uiStatus: QuoteOfTheDayUIStatus.success,
        ),
      ),
    );
  }

  void _onAddToFavorites(
    AddToFavorites event,
    Emitter<QuoteOfTheDayState> emit,
  ) async {
    emit(
      state.copyWith(
        quote: state.quote!.copyWith(isFavorited: true),
        uiStatus: QuoteOfTheDayUIStatus.success,
      ),
    );

    final result = await addFavorite(AddFavoriteParams(quoteId: event.quoteId));

    emit(
      result.fold(
        (failure) => state.copyWith(
          error: 'unknow error',
          uiStatus: QuoteOfTheDayUIStatus.favoriteError,
        ),
        (quote) => state.copyWith(
          quote: quote,
          uiStatus: QuoteOfTheDayUIStatus.success,
        ),
      ),
    );
  }

  void _onDeleteFromFavorites(
    DeleteFromFavorites event,
    Emitter<QuoteOfTheDayState> emit,
  ) async {
    emit(
      state.copyWith(
        quote: state.quote!.copyWith(isFavorited: false),
        uiStatus: QuoteOfTheDayUIStatus.success,
      ),
    );

    final result = await deleteFavorite(
      DeleteFavoriteParams(id: event.quoteId),
    );

    emit(
      result.fold(
        (failure) => state.copyWith(
          error: 'unknow error',
          uiStatus: QuoteOfTheDayUIStatus.unfavoriteError,
        ),
        (success) => state.copyWith(
          quote: state.quote!.copyWith(isFavorited: false),
          uiStatus: QuoteOfTheDayUIStatus.success,
        ),
      ),
    );
  }
}
