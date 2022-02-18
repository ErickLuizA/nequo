import 'package:nequo/domain/entities/quote.dart';

enum DetailsUIStatus { initial, loading, error, success, empty }

class DetailsState {
  final DetailsUIStatus uiStatus;
  final String error;
  final Quote quote;

  DetailsState({
    required this.uiStatus,
    this.error = '',
    required this.quote,
  });

  bool get isLoading => uiStatus == DetailsUIStatus.loading;
  bool get hasError => uiStatus == DetailsUIStatus.error;
  bool get hasData => uiStatus == DetailsUIStatus.success;

  DetailsState copyWith({
    DetailsUIStatus? uiStatus,
    String? error,
    Quote? quote,
  }) {
    return DetailsState(
      uiStatus: uiStatus ?? this.uiStatus,
      error: error ?? this.error,
      quote: quote ?? this.quote,
    );
  }
}
