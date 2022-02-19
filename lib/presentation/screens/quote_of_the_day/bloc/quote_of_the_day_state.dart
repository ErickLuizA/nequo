import 'package:nequo/domain/entities/quote.dart';

enum QuoteOfTheDayUIStatus {
  initial,
  loading,
  error,
  success,
}

enum QuoteOfTheDayActionStatus { initial, favoriteError, unfavoriteError }

class QuoteOfTheDayState {
  final QuoteOfTheDayUIStatus uiStatus;
  final QuoteOfTheDayActionStatus actionStatus;
  final String error;
  final Quote? quote;

  QuoteOfTheDayState({
    this.uiStatus = QuoteOfTheDayUIStatus.initial,
    this.actionStatus = QuoteOfTheDayActionStatus.initial,
    this.error = '',
    this.quote,
  });

  bool get isLoading => uiStatus == QuoteOfTheDayUIStatus.loading;
  bool get hasError => uiStatus == QuoteOfTheDayUIStatus.error;
  bool get hasData => uiStatus == QuoteOfTheDayUIStatus.success;

  QuoteOfTheDayState copyWith({
    QuoteOfTheDayUIStatus? uiStatus,
    QuoteOfTheDayActionStatus? actionStatus,
    String? error,
    Quote? quote,
  }) {
    return QuoteOfTheDayState(
      uiStatus: uiStatus ?? this.uiStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      error: error ?? this.error,
      quote: quote ?? this.quote,
    );
  }
}
