import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/delete_quote_list.dart';

abstract class DeleteEvent {}

class DeleteQuoteEvent extends DeleteEvent {
  DeleteQuoteParams params;

  DeleteQuoteEvent({
    required this.params,
  });
}

class DeleteQuoteListEvent extends DeleteEvent {
  DeleteQuoteListParams params;

  DeleteQuoteListEvent({
    required this.params,
  });
}
