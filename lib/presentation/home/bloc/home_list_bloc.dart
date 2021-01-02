import 'package:NeQuo/domain/usecases/load_quotes_list.dart';
import 'package:NeQuo/domain/usecases/usecase.dart';
import 'package:NeQuo/presentation/home/bloc/home_list_event.dart';
import 'package:NeQuo/presentation/home/bloc/home_list_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeListBloc extends Bloc<HomeListEvent, HomeListState> {
  LoadQuotesList loadQuotesList;

  HomeListBloc({
    @required this.loadQuotesList,
  }) : super(InitialListState());

  @override
  Stream<HomeListState> mapEventToState(HomeListEvent event) async* {
    if (event is GetQuotesList) {
      yield LoadingListState();

      final result = await loadQuotesList(NoParams());

      yield result.fold(
        (failure) => ErrorListState(),
        (success) {
          if (success.isEmpty) {
            return EmptyListState();
          } else {
            return SuccessListState(quoteList: success);
          }
        },
      );
    }
  }
}
