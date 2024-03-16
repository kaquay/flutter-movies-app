import 'dart:async';

import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/domain/usecases/movies/fetch_movie_list_usecase.dart';
import 'package:movies_app/presentation/base/base_bloc.dart';
import 'package:movies_app/presentation/base/state.dart';

class HomeBloC extends BloC {
  final FetchMovieListUseCase _fetchMovieListUseCase;

  HomeBloC(this._fetchMovieListUseCase);

  final StreamController<AppState<List<Movie>>> _moviesStreamController =
      StreamController();
  Stream<AppState<List<Movie>>> get moviesStream =>
      _moviesStreamController.stream;

  Future getMovies() async {
    _moviesStreamController.add(AppState.loading());
    try {
      List<Movie> movies = await _fetchMovieListUseCase.execute();
      _moviesStreamController.add(AppState.success(movies));
    } catch (e) {
      _moviesStreamController.add(AppState.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _moviesStreamController.close();
  }
}
