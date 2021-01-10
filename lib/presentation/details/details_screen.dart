import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/domain/usecases/delete_quote.dart';
import 'package:NeQuo/domain/usecases/delete_quote_list.dart';
import 'package:NeQuo/presentation/details/bloc/delete_bloc.dart';
import 'package:NeQuo/presentation/details/bloc/delete_event.dart';
import 'package:NeQuo/presentation/details/bloc/delete_state.dart';
import 'package:NeQuo/presentation/shared/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/entities/favorite.dart';
import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/domain/usecases/load_quotes.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/details/bloc/details_bloc.dart';
import 'package:NeQuo/presentation/details/bloc/details_event.dart';
import 'package:NeQuo/presentation/details/bloc/details_state.dart';
import 'package:NeQuo/presentation/shared/action_button.dart';

class DetailsScreen extends StatefulWidget {
  final QuoteList quoteList;
  final Function getQuotesList;

  const DetailsScreen({
    Key key,
    this.quoteList,
    this.getQuotesList,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  DetailsBloc _detailsBloc;
  FavoriteBloc _favoriteBloc;
  DeleteBloc _deleteBloc;

  ShareQuote share;

  int current = 0;

  @override
  void initState() {
    super.initState();

    _detailsBloc = getIt<DetailsBloc>();
    _favoriteBloc = getIt<FavoriteBloc>();

    _deleteBloc = getIt<DeleteBloc>();

    share = getIt<ShareQuote>();

    getQuotes();
  }

  @override
  void dispose() {
    super.dispose();

    _detailsBloc.close();
    _favoriteBloc.close();
    _deleteBloc.close();
  }

  void getQuotes() {
    _detailsBloc.add(
      GetQuotes(
        params: LoadQuotesParams(id: widget.quoteList.id),
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

  void handleDeleteQuote(DeleteQuoteParams params) async {
    _deleteBloc.add(
      DeleteQuoteEvent(params: params),
    );
  }

  void handleDeleteQuoteList() async {
    _deleteBloc.add(
      DeleteQuoteListEvent(
        params: DeleteQuoteListParams(id: widget.quoteList.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _detailsBloc,
          ),
          BlocProvider(
            create: (_) => _favoriteBloc,
          ),
          BlocProvider(
            create: (_) => _deleteBloc,
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: BlocBuilder<DetailsBloc, DetailsState>(
            builder: (context, state) {
              if (state is EmptyState) {
                return SafeArea(
                  child: Container(
                    child: Column(
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
                            BlocBuilder<DeleteBloc, DeleteState>(
                              builder: (_, deleteListState) {
                                if (deleteListState is DeleteListLoadingState) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (deleteListState
                                    is DeleteListErrorState) {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context)
                                          .translate("del_quote_list_error")),
                                    ),
                                  );
                                  return PopupMenuButton<String>(
                                    onSelected: (val) {
                                      if (val ==
                                          AppLocalizations.of(context)
                                              .translate("del_list")) {
                                        handleDeleteQuoteList();
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return {
                                        AppLocalizations.of(context)
                                            .translate("del_list")
                                      }.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  );
                                } else if (deleteListState
                                    is DeleteListSuccessState) {
                                  widget.getQuotesList();

                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.pop(context);
                                  });

                                  return Container();
                                } else {
                                  return PopupMenuButton<String>(
                                    onSelected: (val) {
                                      if (val ==
                                          AppLocalizations.of(context)
                                              .translate("del_list")) {
                                        handleDeleteQuoteList();
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return {
                                        AppLocalizations.of(context)
                                            .translate("del_list")
                                      }.map((String choice) {
                                        return PopupMenuItem<String>(
                                          value: choice,
                                          child: Text(choice),
                                        );
                                      }).toList();
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hourglass_empty_outlined,
                                size: 50,
                              ),
                              Text(AppLocalizations.of(context)
                                  .translate("empty_list")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
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
                        BlocBuilder<DeleteBloc, DeleteState>(
                          builder: (_, delListState) {
                            if (delListState is DeleteListLoadingState) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (delListState is DeleteListErrorState) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .translate("del_quote_list_error")),
                                ),
                              );
                              return PopupMenuButton<String>(
                                onSelected: (val) {
                                  if (val ==
                                      AppLocalizations.of(context)
                                          .translate("del_list")) {
                                    handleDeleteQuoteList();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return {
                                    AppLocalizations.of(context)
                                        .translate("del_list")
                                  }.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              );
                            } else if (delListState is DeleteListSuccessState) {
                              widget.getQuotesList();

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              });

                              return Container();
                            } else {
                              return PopupMenuButton<String>(
                                onSelected: (val) {
                                  if (val ==
                                      AppLocalizations.of(context)
                                          .translate("del_list")) {
                                    handleDeleteQuoteList();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return {
                                    AppLocalizations.of(context)
                                        .translate("del_list")
                                  }.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              );
                            }
                          },
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
                          itemBuilder: (context, index) {
                            final quote = state.quotes[index];

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                current = index;
                              });
                            });

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
                          builder: (_, favState) {
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
                        BlocBuilder<DeleteBloc, DeleteState>(
                          builder: (_, delState) {
                            if (delState is DeleteLoadingState) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (delState is DeleteErrorState) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .translate("del_quote_error")),
                                ),
                              );
                              return ActionButton(
                                icon: Icons.delete_outline,
                                onPress: () {
                                  handleDeleteQuote(
                                    DeleteQuoteParams(
                                      id: state.quotes[current].id,
                                    ),
                                  );
                                },
                              );
                            } else if (delState is DeleteSuccessState) {
                              getQuotes();

                              return ActionButton(
                                icon: Icons.delete_outline,
                                onPress: () {
                                  handleDeleteQuote(
                                    DeleteQuoteParams(
                                      id: state.quotes[current].id,
                                    ),
                                  );
                                },
                              );
                            } else {
                              return ActionButton(
                                icon: Icons.delete_outline,
                                onPress: () {
                                  handleDeleteQuote(
                                    DeleteQuoteParams(
                                      id: state.quotes[current].id,
                                    ),
                                  );
                                },
                              );
                            }
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
