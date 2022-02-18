abstract class DetailsEvent {}

class GetQuoteEvent extends DetailsEvent {
  final int id;

  GetQuoteEvent({
    required this.id,
  });
}
