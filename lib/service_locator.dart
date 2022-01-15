import 'package:nequo/domain/usecases/add_favorite.dart';
import 'package:nequo/domain/usecases/add_quote.dart';
import 'package:nequo/domain/usecases/add_quote_list.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
import 'package:nequo/domain/usecases/delete_quote.dart';
import 'package:nequo/domain/usecases/delete_quote_list.dart';
import 'package:nequo/domain/usecases/load_favorites.dart';
import 'package:nequo/domain/usecases/load_quotes.dart';
import 'package:nequo/domain/usecases/load_quotes_list.dart';
import 'package:nequo/domain/usecases/load_random_quote.dart';
import 'package:nequo/domain/usecases/load_random_quotes.dart';
import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/domain/repositories/quote_repository.dart';
import 'package:nequo/domain/repositories/favorite_repository.dart';
import 'package:nequo/data/datasources/favorite_local_datasource.dart';
import 'package:nequo/data/datasources/quote_local_datasource.dart';
import 'package:nequo/data/datasources/quote_remote_datasource.dart';
import 'package:nequo/data/repositories/favorite_repository_impl.dart';
import 'package:nequo/data/repositories/quote_repository_impl.dart';
import 'package:nequo/external/datasources/favorite_local_datasource_impl.dart';
import 'package:nequo/external/datasources/quote_local_datasource_impl.dart';
import 'package:nequo/external/datasources/quote_remote_datasource_impl.dart';
import 'package:nequo/external/services/database.dart';
import 'package:nequo/external/services/network_info.dart';
import 'package:nequo/external/services/share.dart';
import 'package:nequo/presentation/details/bloc/details_bloc.dart';
import 'package:nequo/presentation/details/bloc/delete_bloc.dart';
import 'package:nequo/presentation/favorites/bloc/favorites_bloc.dart';
import 'package:nequo/presentation/shared/bloc/favorite_bloc.dart';
import 'package:nequo/presentation/home/bloc/home_list_bloc.dart';
import 'package:nequo/presentation/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
import 'package:nequo/presentation/random_details/bloc/random_details_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mockito/mockito.dart';

final getIt = GetIt.instance;

Future<void> setUp({bool testing = false}) async {
  // Bloc
  getIt.registerFactory(
    () => QuoteOfTheDayBloc(
      loadRandomQuote: getIt(),
    ),
  );
  getIt.registerFactory(
    () => HomeListBloc(
      loadQuotesList: getIt(),
    ),
  );
  getIt.registerFactory(
    () => RandomDetailsBloc(
      loadRandomQuotes: getIt(),
    ),
  );
  getIt.registerFactory(
    () => DetailsBloc(
      loadQuotes: getIt(),
    ),
  );
  getIt.registerFactory(
    () => DeleteBloc(
      deleteQuote: getIt(),
      deleteQuoteList: getIt(),
    ),
  );
  getIt.registerFactory(
    () => FavoriteBloc(
      addFavorite: getIt(),
    ),
  );
  getIt.registerFactory(
    () => FavoritesBloc(
      loadFavorites: getIt(),
      deleteFavorite: getIt(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(
    () => LoadRandomQuote(
      quoteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => LoadRandomQuotes(
      quoteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => LoadQuotesList(
      quoteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => LoadQuotes(
      quoteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => ShareQuote(
      share: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => AddFavorite(
      favoriteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => LoadFavorites(
      favoriteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteFavorite(
      favoriteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteQuote(
      quoteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteQuoteList(
      quoteRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => AddQuoteList(
      quoteListRepository: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => AddQuote(
      quoteRepository: getIt(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(
      favoriteLocalDatasource: getIt(),
    ),
  );

  // Datasources
  getIt.registerLazySingleton<QuoteRemoteDatasource>(
    () => QuoteRemoteDatasourceImpl(
      client: getIt(),
    ),
  );
  getIt.registerLazySingleton<QuoteLocalDatasource>(
    () => QuoteLocalDatasourceImpl(
      sharedPreferences: getIt(),
      database: getIt(),
    ),
  );
  getIt.registerLazySingleton<FavoriteLocalDatasource>(
    () => FavoriteLocalDatasourceImpl(
      database: getIt(),
    ),
  );

  // External

  if (testing) {
    getIt.registerLazySingleton<http.Client>(() => ClientMock());
    getIt.registerLazySingleton<SharedPreferences>(
        () => SharedPreferencesMock());
    getIt.registerLazySingleton<Database>(() => DatabaseMock());
    getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
    getIt.registerLazySingleton<Share>(() => ShareImpl());
  } else {
    final sharedPreferences = await SharedPreferences.getInstance();
    final database = await initDb();

    getIt.registerLazySingleton(() => http.Client());
    getIt.registerLazySingleton(() => sharedPreferences);
    getIt.registerLazySingleton(() => database);
    getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
    getIt.registerLazySingleton<Share>(() => ShareImpl());
  }
}

class ClientMock extends Mock implements http.Client {}

class SharedPreferencesMock extends Mock implements SharedPreferences {}

class DatabaseMock extends Mock implements Database {}
