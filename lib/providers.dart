import 'package:movies_app/domain/usecases/movies/fetch_movie_list_usecase.dart';
import 'package:movies_app/presentation/modules/home/home_bloc.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:movies_app/data/datasources/remote/rest_client.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';

List<InheritedProvider> getProviders() {
  List appModule = [
    Provider<Dio>(create: (_) => Dio()),
    ProxyProvider<Dio, RestClient>(
      update: (_, dio, client) => RestClient(dio),
    ),
  ];
  List repositories = [
    ProxyProvider<RestClient, MovieRepository>(
      update: (_, client, repository) => MovieRepositoryImpl(client),
    ),
  ];

  List usecases = [
    ProxyProvider<MovieRepository, FetchMovieListUseCase>(
      update: (_, repo, usecase) => FetchMovieListUseCase(repo),
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
