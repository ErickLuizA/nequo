import 'package:NeQuo/app_localizations.dart';
import 'package:NeQuo/domain/usecases/add_quote.dart';
import 'package:NeQuo/domain/usecases/add_quote_list.dart';
import 'package:NeQuo/presentation/shared/widgets/loading_widget.dart';
import 'package:NeQuo/service_locator.dart';
import 'package:NeQuo/domain/entities/quote_list.dart';
import 'package:NeQuo/domain/usecases/share_quote.dart';
import 'package:NeQuo/presentation/home/bloc/home_list_bloc.dart';
import 'package:NeQuo/presentation/home/bloc/home_list_event.dart';
import 'package:NeQuo/presentation/home/bloc/home_list_state.dart';
import 'package:NeQuo/presentation/home/utils/random_id.dart';
import 'package:NeQuo/presentation/home/widgets/bottom_sheet_widget.dart';
import 'package:NeQuo/presentation/home/widgets/drawer_widget.dart';
import 'package:NeQuo/presentation/shared/widgets/load_error_widget.dart';
import 'package:NeQuo/presentation/home/widgets/quote_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeListBloc _homeListBloc;
  ShareQuote share;
  AddQuoteList _addQuoteList;
  AddQuote _addQuote;
  List<QuoteList> quoteList;

  @override
  void initState() {
    super.initState();
    _homeListBloc = getIt<HomeListBloc>();
    share = getIt<ShareQuote>();
    _addQuoteList = getIt<AddQuoteList>();
    _addQuote = getIt<AddQuote>();

    getQuotesList();
  }

  @override
  void dispose() {
    super.dispose();
    _homeListBloc.close();
  }

  void handleNavigateToFavorites() {
    Navigator.of(context).pushNamed('/favorites');
  }

  void handleShare() async {
    await share(ShareParams(
      subject: 'NeQuo - Quotes App',
      text: AppLocalizations.of(context).translate('find_quotes'),
    ));
  }

  void getQuotesList() {
    _homeListBloc.add(GetQuotesList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      endDrawer: DrawerWidget(
        handleNavigateToFavorites: handleNavigateToFavorites,
        handleShare: handleShare,
      ),
      appBar: AppBar(
        title: Text(
          "NeQuo",
          style: GoogleFonts.marckScript(
            fontSize: 32,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => _homeListBloc,
        child: Column(
          key: Key("home_screen"),
          mainAxisSize: MainAxisSize.min,
          children: [
            QuoteListCard(
              id: ID,
              name: AppLocalizations.of(context).translate('random_quotes'),
            ),
            BlocBuilder<HomeListBloc, HomeListState>(
              builder: (context, state) {
                if (state is LoadingListState) {
                  return LoadingWidget(Key("loading"));
                } else if (state is ErrorListState) {
                  return LoadErrorWidget(
                    key: Key("load_error_widget"),
                    text:
                        AppLocalizations.of(context).translate('load_ql_error'),
                    retry: getQuotesList,
                  );
                } else if (state is SuccessListState) {
                  return Flexible(
                    key: Key("success_list_state"),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.quoteList.length,
                      itemBuilder: (context, index) {
                        quoteList = state.quoteList;

                        final list = state.quoteList[index];

                        return QuoteListCard(
                          id: list.id,
                          name: list.name,
                          getQuotesList: getQuotesList,
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    key: Key("empty_list_state"),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (scaffoldContext) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: scaffoldContext,
              backgroundColor: Color(0XFF605c65),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              builder: (context) => BottomSheetWidget(
                key: Key("bottom_sheet_widget"),
                list: quoteList ?? List(),
                scaffoldContext: scaffoldContext,
                getQuotesList: getQuotesList,
                addQuoteList: _addQuoteList,
                addQuote: _addQuote,
              ),
            );
          },
        ),
      ),
    );
  }
}
