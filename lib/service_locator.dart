import 'package:nequo/domain/services/network_info_service.dart';
import 'package:nequo/domain/services/share_service.dart';
import 'package:nequo/domain/usecases/add_favorite.dart';
// import 'package:nequo/domain/usecases/add_quote.dart';
// import 'package:nequo/domain/usecases/add_category.dart';
import 'package:nequo/domain/usecases/delete_favorite.dart';
// import 'package:nequo/domain/usecases/delete_quote.dart';
// import 'package:nequo/domain/usecases/delete_category.dart';
// import 'package:nequo/domain/usecases/load_favorites.dart';
// import 'package:nequo/domain/usecases/load_quote.dart';
// import 'package:nequo/domain/usecases/load_categories.dart';
import 'package:nequo/domain/usecases/load_quote_of_the_day.dart';
// import 'package:nequo/domain/usecases/load_random_quotes.dart';
// import 'package:nequo/domain/usecases/share_quote.dart';
import 'package:nequo/domain/repositories/quotes_repository.dart';
import 'package:nequo/domain/repositories/favorites_repository.dart';
import 'package:nequo/data/datasources/favorites_local_datasource.dart';
import 'package:nequo/data/datasources/quotes_local_datasource.dart';
import 'package:nequo/data/datasources/quotes_remote_datasource.dart';
import 'package:nequo/data/repositories/favorite_repository_impl.dart';
import 'package:nequo/data/repositories/quote_repository_impl.dart';
import 'package:nequo/external/datasources/favorite_local_datasource_impl.dart';
import 'package:nequo/external/datasources/quote_local_datasource_impl.dart';
import 'package:nequo/external/datasources/quote_remote_datasource_impl.dart';
import 'package:nequo/external/services/database.dart';
import 'package:nequo/external/services/network_info.dart';
import 'package:nequo/external/services/share.dart';
// import 'package:nequo/presentation/details/bloc/details_bloc.dart';
// import 'package:nequo/presentation/details/bloc/delete_bloc.dart';
// import 'package:nequo/presentation/favorites/bloc/favorites_bloc.dart';
// import 'package:nequo/presentation/bloc/favorite_bloc.dart';
// import 'package:nequo/presentation/home/bloc/home_list_bloc.dart';
import 'package:nequo/presentation/screens/quote_of_the_day/bloc/quote_of_the_day_bloc.dart';
// import 'package:nequo/presentation/random_details/bloc/random_details_bloc.dart';

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
      loadQuoteOfTheDay: getIt(),
      addFavorite: getIt(),
      deleteFavorite: getIt(),
    ),
  );
  // getIt.registerFactory(
  //   () => HomeBloc(
  //     loadCategories: getIt(),
  //   ),
  // );
  // getIt.registerFactory(
  //   () => RandomDetailsBloc(
  //     loadRandomQuotes: getIt(),
  //   ),
  // );
  // getIt.registerFactory(
  //   () => DetailsBloc(
  //     loadQuotes: getIt(),
  //   ),
  // );
  // getIt.registerFactory(
  //   () => DeleteBloc(
  //     deleteQuote: getIt(),
  //     deleteCategory: getIt(),
  //   ),
  // );
  // getIt.registerFactory(
  //   () => FavoriteBloc(
  //     loadFavorites: getIt(),
  //     deleteFavorite: getIt(),
  //     addFavorite: getIt(),
  //   ),
  // );
  // getIt.registerFactory(
  //   () => FavoritesBloc(
  //     loadFavorites: getIt(),
  //     deleteFavorite: getIt(),
  //   ),
  // );

  // Usecases
  getIt.registerLazySingleton(
    () => LoadQuoteOfTheDay(
      quoteRepository: getIt(),
    ),
  );
  // getIt.registerLazySingleton(
  //   () => LoadRandomQuotes(
  //     quoteRepository: getIt(),
  //   ),
  // );
  // getIt.registerLazySingleton(
  //   () => LoadCategories(
  //     categoriesRepository: getIt(),
  //   ),
  // );
  // getIt.registerLazySingleton(
  //   () => LoadQuotes(
  //     quoteRepository: getIt(),
  //   ),
  // );
  // getIt.registerLazySingleton(
  //   () => ShareQuote(
  //     shareService: getIt(),
  //   ),
  // );
  getIt.registerLazySingleton(
    () => AddFavorite(
      favoritesRepository: getIt(),
    ),
  );
  // getIt.registerLazySingleton(
  //   () => LoadFavorites(
  //     favoritesRepository: getIt(),
  //   ),
  // );
  getIt.registerLazySingleton(
    () => DeleteFavorite(
      favoritesRepository: getIt(),
    ),
  );
  // getIt.registerLazySingleton(
  //   () => DeleteQuote(
  //     quoteRepository: getIt(),
  //   ),
  // );
  // getIt.registerLazySingleton(
  //   () => DeleteCategory(
  //     categoriesRepository: getIt(),
  //   ),
  // );
  // getIt.registerLazySingleton(
  //   () => AddCategory(
  //     categoriesRepository: getIt(),
  //   ),
  // );
  // getIt.registerLazySingleton(
  //   () => AddQuote(
  //     quoteRepository: getIt(),
  //   ),
  // );

  // Repositories
  getIt.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(
      quotesLocalDatasource: getIt(),
      quotesRemoteDatasource: getIt(),
      networkInfoService: getIt(),
    ),
  );
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      favoritesLocalDatasource: getIt(),
    ),
  );

  // Datasources
  getIt.registerLazySingleton<QuotesRemoteDatasource>(
    () => QuoteRemoteDatasourceImpl(
      client: getIt(),
    ),
  );
  getIt.registerLazySingleton<QuotesLocalDatasource>(
    () => QuoteLocalDatasourceImpl(
      sharedPreferences: getIt(),
      database: getIt(),
    ),
  );
  getIt.registerLazySingleton<FavoritesLocalDatasource>(
    () => FavoriteLocalDatasourceImpl(
      database: getIt(),
    ),
  );

  // External

  if (testing) {
    getIt.registerLazySingleton<http.Client>(
      () => ClientMock(),
    );
    getIt.registerLazySingleton<SharedPreferences>(
      () => SharedPreferencesMock(),
    );
    getIt.registerLazySingleton<Database>(
      () => DatabaseMock(),
    );
    getIt.registerLazySingleton<NetworkInfoService>(
      () => NetworkInfoServiceImpl(),
    );
    getIt.registerLazySingleton<ShareService>(
      () => ShareServiceImpl(),
    );
  } else {
    final sharedPreferences = await SharedPreferences.getInstance();
    final database = await initDb();

    getIt.registerLazySingleton(() => http.Client());
    getIt.registerLazySingleton(() => sharedPreferences);
    getIt.registerLazySingleton(() => database);
    getIt.registerLazySingleton<ShareService>(() => ShareServiceImpl());
    getIt.registerLazySingleton<NetworkInfoService>(
      () => NetworkInfoServiceImpl(),
    );
  }
}

class ClientMock extends Mock implements http.Client {}

class SharedPreferencesMock extends Mock implements SharedPreferences {}

class DatabaseMock extends Mock implements Database {}
