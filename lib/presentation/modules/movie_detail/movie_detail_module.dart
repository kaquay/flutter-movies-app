import 'package:flutter/material.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/domain/usecases/movies/add_movie_to_watch_list_usecase.dart';
import 'package:movies_app/domain/usecases/movies/remove_movie_to_watch_list_usecase.dart';
import 'package:movies_app/presentation/modules/movie_detail/movie_detail_bloc.dart';
import 'package:movies_app/presentation/modules/movie_detail/movie_detail_screen.dart';
import 'package:provider/provider.dart';

Future openMovieDetail(BuildContext context, Movie movie) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MultiProvider(
        providers: getMovieDetailModule(),
        child: MovieDetailScreen(movie: movie),
      ),
    ),
  );
}

List<InheritedProvider> getMovieDetailModule() {
  List usecases = [];

  List blocs = [
    ProxyProvider2<AddMovieToWatchListUseCase, RemoveMovieToWatchListUseCase,
        MovieDetailBloC>(
      update: (_, u1, u2, bloC) => bloC ?? MovieDetailBloC(u1, u2),
      dispose: (_, bloc) => bloc.dispose(),
    ),
  ];
  return [
    ...usecases,
    ...blocs,
  ];
}
