import 'package:nequo/domain/entities/quote.dart';

enum FavoritesUIStatus { initial, loading, error, success, empty }

enum FavoritesActionStatus { initial, deleteError }

class FavoritesState {
  final FavoritesUIStatus uiStatus;
  final FavoritesActionStatus actionStatus;
  final List<Quote> favorites;
  final List<Quote> previousFavorites;
  final String error;

  FavoritesState({
    required this.uiStatus,
    required this.favorites,
    this.previousFavorites = const [],
    this.actionStatus = FavoritesActionStatus.initial,
    this.error = '',
  });

  bool get isLoading => uiStatus == FavoritesUIStatus.loading;
  bool get hasError => uiStatus == FavoritesUIStatus.error;
  bool get isEmpty => uiStatus == FavoritesUIStatus.empty;
  bool get hasData => uiStatus == FavoritesUIStatus.success;

  FavoritesState copyWith({
    FavoritesUIStatus? uiStatus,
    FavoritesActionStatus? actionStatus,
    String? error,
    List<Quote>? favorites,
    List<Quote>? previousFavorites,
  }) {
    return FavoritesState(
      uiStatus: uiStatus ?? this.uiStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      error: error ?? this.error,
      favorites: favorites ?? this.favorites,
      previousFavorites: previousFavorites ?? this.previousFavorites,
    );
  }
}
