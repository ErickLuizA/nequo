import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/usecases/delete_favorite.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_bloc.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_event.dart';
import 'package:NeQuo/presentation/favorites/bloc/favorites_state.dart';
import 'package:NeQuo/presentation/shared/action_button.dart';
import 'package:NeQuo/presentation/shared/load_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoritesBloc _favoritesBloc;
  ShareQuote share;

  int current = 0;

  @override
  void initState() {
    super.initState();

    _favoritesBloc = getIt<FavoritesBloc>();
    share = getIt<ShareQuote>();

    getFavorites();
  }

  @override
  void dispose() {
    super.dispose();

    _favoritesBloc.close();
  }

  void getFavorites() {
    _favoritesBloc.add(GetFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _favoritesBloc,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
            if (state is EmptyState) {
              return SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hourglass_empty_outlined,
                                size: 50,
                              ),
                              Text(AppLocalizations.of(context)
                                  .translate('empty_list')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is FailedState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate('del_fav_error')),
                ),
              );
              return Center(
                child: CircularProgressIndicator(),
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
                      Text("${current + 1}/${state.favorites.length}"),
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
                        itemCount: state.favorites.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final quote = state.favorites[index];

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
                                  style: Theme.of(context).textTheme.bodyText1,
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
                              text: state.favorites[current].content,
                              subject: 'NeQuo - Quotes app',
                            ),
                          );
                        },
                      ),
                      ActionButton(
                        icon: Icons.delete_outline,
                        onPress: () {
                          _favoritesBloc.add(
                            DeleteFavoriteEvent(
                              params: DeleteFavoriteParams(
                                  id: state.favorites[current].id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return LoadErrorWidget(
                retry: getFavorites,
                text: AppLocalizations.of(context).translate("load_fav_error"),
              );
            }
          }),
        ),
      ),
    );
  }
}
