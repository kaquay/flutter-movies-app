import 'package:movies_app/presentation/modules/global/movie_manager.dart';
import 'package:movies_app/presentation/modules/home/home_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:movies_app/data/datasources/remote/rest_client.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';

import 'domain/usecases/usecases.dart';

List<InheritedProvider> getProviders() {
  List appModule = [
    Provider<Dio>(create: (_) => Dio()),
    ProxyProvider<Dio, RestClient>(
      update: (_, dio, client) => RestClient(dio),
    ),
    Provider<MovieManager>(
      create: (_) => MovieManagerImpl(),
      dispose: (_, value) => value.dispose(),
    )
  ];
  List repositories = [
    ProxyProvider<RestClient, MovieRepository>(
      update: (_, client, repository) => MovieRepositoryImpl(client),
    ),
  ];

  List usecases = [
    ProxyProvider2<MovieRepository, MovieManager, FetchMovieListUseCase>(
      update: (_, repo, movieManager, usecase) =>
          FetchMovieListUseCase(repo, movieManager),
    ),
    ProxyProvider<MovieManager, AddMovieToWatchListUseCase>(
      update: (_, manage, usecase) => AddMovieToWatchListUseCase(manage),
    ),
    ProxyProvider<MovieManager, RemoveMovieToWatchListUseCase>(
      update: (_, manage, usecase) => RemoveMovieToWatchListUseCase(manage),
    ),
    ProxyProvider<MovieManager, FetchWatchListUseCase>(
      update: (_, manage, usecase) => FetchWatchListUseCase(manage),
    ),
  ];

  List blocs = [
    ProxyProvider<FetchMovieListUseCase, HomeBloC>(
      update: (_, usecase, bloC) => bloC ?? HomeBloC(usecase),
      dispose: (_, bloc) => bloc.dispose(),
    ),
  ];

  return [
    ...appModule,
    ...repositories,
    ...usecases,
    ...blocs,
  ];
}
