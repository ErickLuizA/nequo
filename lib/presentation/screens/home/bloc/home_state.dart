import 'package:nequo/domain/entities/quote.dart';

enum HomeUIStatus { initial, loading, error, success, empty }

class HomeState {
  final HomeUIStatus uiStatus;
  final String error;
  final List<Quote> quotes;

  HomeState({
    required this.uiStatus,
    this.error = '',
    required this.quotes,
  });

  bool get isLoading => uiStatus == HomeUIStatus.loading;
  bool get isEmpty => uiStatus == HomeUIStatus.empty;
  bool get hasError => uiStatus == HomeUIStatus.error;
  bool get hasData => uiStatus == HomeUIStatus.success;

  HomeState copyWith({
    HomeUIStatus? uiStatus,
    String? error,
    List<Quote>? quotes,
  }) {
    return HomeState(
      uiStatus: uiStatus ?? this.uiStatus,
      error: error ?? this.error,
      quotes: quotes ?? this.quotes,
    );
  }
}
