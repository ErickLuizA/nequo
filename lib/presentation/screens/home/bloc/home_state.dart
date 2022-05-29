import 'package:nequo/domain/entities/quote.dart';

enum HomeUIStatus { initial, loading, error, paginationError, success, empty }

class HomeState {
  final HomeUIStatus uiStatus;
  final String error;
  final List<Quote> quotes;
  final int page;
  final int lastPage;

  HomeState({
    required this.uiStatus,
    required this.quotes,
    required this.page,
    required this.lastPage,
    this.error = '',
  });

  bool get isLoading => uiStatus == HomeUIStatus.loading;
  bool get isEmpty => uiStatus == HomeUIStatus.empty;
  bool get hasError => uiStatus == HomeUIStatus.error;
  bool get hasPaginationError => uiStatus == HomeUIStatus.paginationError;
  bool get hasData => uiStatus == HomeUIStatus.success;

  HomeState copyWith({
    HomeUIStatus? uiStatus,
    List<Quote>? quotes,
    int? page,
    int? lastPage,
    String? error,
  }) {
    return HomeState(
      uiStatus: uiStatus ?? this.uiStatus,
      quotes: quotes ?? this.quotes,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      error: error ?? this.error,
    );
  }
}
