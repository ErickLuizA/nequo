abstract class HomeEvent {}

class GetQuotesEvent extends HomeEvent {}

class GetNextQuotesEvent extends HomeEvent {
  final int page;

  GetNextQuotesEvent({
    required this.page,
  });
}
