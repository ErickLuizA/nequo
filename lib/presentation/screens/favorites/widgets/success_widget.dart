import 'package:flutter/material.dart';
import 'package:nequo/domain/entities/quote.dart';
import 'package:nequo/presentation/widgets/quote_card.dart';

class SuccessWidget extends StatelessWidget {
  final List<Quote> favorites;
  final Function(int id, {bool isPermanent, List<Quote> quotes}) deleteFavorite;
  final Function(int id, List<Quote> quotes) undoDeleteFavorite;

  const SuccessWidget({
    Key? key,
    required this.favorites,
    required this.deleteFavorite,
    required this.undoDeleteFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final quote = favorites[index];

        return Dismissible(
          key: Key(quote.id.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (_) async {
            deleteFavorite(quote.id);

            final controller = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Favorito deletado com sucesso!'),
                action: SnackBarAction(
                  label: 'Undo',
                  textColor: Theme.of(context).colorScheme.onSurface,
                  onPressed: () {
                    undoDeleteFavorite(quote.id, favorites);
                  },
                ),
                duration: Duration(seconds: 2, milliseconds: 500),
                dismissDirection: DismissDirection.endToStart,
              ),
            );

            final reason = await controller.closed;

            if (reason != SnackBarClosedReason.action) {
              deleteFavorite(quote.id, isPermanent: true, quotes: favorites);
            }
          },
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red.shade400,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete_sweep_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: QuoteCard(
              quote: quote,
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}
