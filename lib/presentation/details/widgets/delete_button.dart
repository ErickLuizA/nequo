import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nequo/app_localizations.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/presentation/details/bloc/delete_bloc.dart';
import 'package:nequo/presentation/details/bloc/delete_state.dart';
import 'package:nequo/presentation/details/bloc/details_state.dart';
import 'package:nequo/presentation/shared/widgets/action_button.dart';
import 'package:nequo/presentation/shared/widgets/loading_widget.dart';

class DeleteButton extends StatelessWidget {
  final Function(DeleteQuoteParams params) handleDeleteQuote;
  final Function getQuotes;
  final SuccessState successState;
  final int current;

  const DeleteButton({
    Key? key,
    required this.handleDeleteQuote,
    required this.getQuotes,
    required this.successState,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteBloc, DeleteState>(
      key: Key("delete_button_bloc_builder"),
      builder: (_, state) {
        if (state is DeleteLoadingState) {
          return LoadingWidget(
            key: Key("delete_loading"),
          );
        } else if (state is DeleteErrorState) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                key: Key("error_snackbar"),
                content: Text(
                    AppLocalizations.of(context).translate("del_quote_error")),
              ),
            );
          });

          return ActionButton(
            key: Key("error_delete_button"),
            icon: Icons.delete_outline,
            onPress: () {
              handleDeleteQuote(
                DeleteQuoteParams(
                  id: successState.quotes[current].id!,
                ),
              );
            },
          );
        } else if (state is DeleteSuccessState) {
          getQuotes();

          return ActionButton(
            icon: Icons.delete_outline,
            onPress: () {
              handleDeleteQuote(
                DeleteQuoteParams(
                  id: successState.quotes[current].id!,
                ),
              );
            },
          );
        } else {
          return ActionButton(
            key: Key("delete_button"),
            icon: Icons.delete_outline,
            onPress: () {
              handleDeleteQuote(
                DeleteQuoteParams(
                  id: successState.quotes[current].id!,
                ),
              );
            },
          );
        }
      },
    );
  }
}
