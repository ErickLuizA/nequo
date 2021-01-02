import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote_list.dart';

abstract class DeleteEvent {}

class DeleteQuoteEvent extends DeleteEvent {
  DeleteQuoteParams params;

  DeleteQuoteEvent({
    this.params,
  });
}

class DeleteQuoteListEvent extends DeleteEvent {
  DeleteQuoteListParams params;

  DeleteQuoteListEvent({
    this.params,
  });
}
