import 'package:nequo/domain/entities/quote.dart';

enum DetailsUIStatus { initial, loading, error, success, empty }

enum DetailsActionStatus { initial, favoriteError, unfavoriteError }

class DetailsState {
  final DetailsUIStatus uiStatus;
  final DetailsActionStatus actionStatus;
  final String error;
  final Quote quote;

  DetailsState({
    required this.uiStatus,
    required this.quote,
    this.actionStatus = DetailsActionStatus.initial,
    this.error = '',
  });

  bool get isLoading => uiStatus == DetailsUIStatus.loading;
  bool get hasError => uiStatus == DetailsUIStatus.error;
  bool get hasData => uiStatus == DetailsUIStatus.success;

  DetailsState copyWith({
    DetailsUIStatus? uiStatus,
    DetailsActionStatus? actionStatus,
    String? error,
    Quote? quote,
  }) {
    return DetailsState(
      uiStatus: uiStatus ?? this.uiStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      error: error ?? this.error,
      quote: quote ?? this.quote,
    );
  }
}
