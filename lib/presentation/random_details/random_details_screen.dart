import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/usecases/load_random_quotes.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_bloc.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_event.dart';
import 'package:NeQuo/presentation/random_details/bloc/random_details_state.dart';
import 'package:NeQuo/presentation/shared/action_button.dart';
import 'package:NeQuo/presentation/shared/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomDetailsScreen extends StatefulWidget {
  @override
  _RandomDetailsScreenState createState() => _RandomDetailsScreenState();
}

class _RandomDetailsScreenState extends State<RandomDetailsScreen> {
  RandomDetailsBloc _randomDetailsBloc;
  FavoriteBloc _favoriteBloc;

  ShareQuote share;

  int current = 0;

  @override
  void initState() {
    super.initState();

    _randomDetailsBloc = getIt<RandomDetailsBloc>();
    _favoriteBloc = getIt<FavoriteBloc>();
    share = getIt<ShareQuote>();

    getRandomQuotes(0, 0);
  }

  @override
  void dispose() {
    super.dispose();

    _randomDetailsBloc.close();
    _favoriteBloc.close();
  }

  void getRandomQuotes(int skip, int scrollPos) {
    _randomDetailsBloc.add(
      GetRandomQuotes(
        params: LoadRandomQuotesParams(skip: skip),
        scrollPos: scrollPos,
      ),
    );
  }

  void handleFavorite(Favorite fav, int index) async {
    _favoriteBloc.add(
      AddFavoriteEvent(
        favorite: fav,
        index: index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _randomDetailsBloc,
          ),
          BlocProvider(
            create: (_) => _favoriteBloc,
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: BlocBuilder<RandomDetailsBloc, RandomDetailsState>(
            builder: (context, state) {
              if (state is EmptyState) {
                return Container();
              } else if (state is LoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SuccessState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text("${current + 1}/${state.quotes.length}"),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: PageView.builder(
                          itemCount: state.quotes.length,
                          scrollDirection: Axis.horizontal,
                          controller: PageController(
                            initialPage: state.scrollPos,
                          ),
                          itemBuilder: (context, index) {
                            final quote = state.quotes[index];

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                current = index;
                              });
                            });

                            if (index == state.quotes.length - 1) {
                              getRandomQuotes(state.quotes.length, index + 1);
                            }

                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Text(
                                    quote.content,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "- ${quote.author}",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionButton(
                          icon: Icons.share_outlined,
                          onPress: () {
                            share(
                              ShareParams(
                                text: state.quotes[current].content,
                                subject: 'NeQuo - Quotes app',
                              ),
                            );
                          },
                        ),
                        BlocBuilder<FavoriteBloc, FavoriteState>(
                          builder: (context, favState) {
                            final isFavorite =
                                favState.favIndex.contains(current);

                            return isFavorite
                                ? ActionButton(
                                    icon: Icons.favorite,
                                    onPress: () {},
                                  )
                                : ActionButton(
                                    icon: Icons.favorite_outline,
                                    onPress: () {
                                      handleFavorite(
                                        Favorite(
                                          author: state.quotes[current].author,
                                          content:
                                              state.quotes[current].content,
                                        ),
                                        current,
                                      );
                                    },
                                  );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
