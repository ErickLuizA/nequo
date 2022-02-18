import 'package:nequo/domain/entities/quote.dart';

enum FavoritesUIStatus { initial, loading, error, success, empty }

class FavoritesState {
  final FavoritesUIStatus uiStatus;
  final List<Quote> favorites;
  final String error;

  FavoritesState({
    required this.uiStatus,
    this.error = '',
    required this.favorites,
  });

  bool get isLoading => uiStatus == FavoritesUIStatus.loading;
  bool get hasError => uiStatus == FavoritesUIStatus.error;
  bool get hasData => uiStatus == FavoritesUIStatus.success;

  FavoritesState copyWith({
    FavoritesUIStatus? uiStatus,
    String? error,
    List<Quote>? favorites,
  }) {
    return FavoritesState(
      uiStatus: uiStatus ?? this.uiStatus,
      error: error ?? this.error,
      favorites: favorites ?? this.favorites,
    );
  }
}
