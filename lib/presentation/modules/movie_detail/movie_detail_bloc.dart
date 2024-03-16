import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/domain/usecases/movies/add_movie_to_watch_list_usecase.dart';
import 'package:movies_app/domain/usecases/movies/remove_movie_to_watch_list_usecase.dart';
import 'package:movies_app/presentation/base/base_bloc.dart';

class MovieDetailBloC extends BloC {
  final AddMovieToWatchListUseCase _addMovieToWatchListUseCase;
  final RemoveMovieToWatchListUseCase _removeMovieToWatchListUseCase;

  MovieDetailBloC(
      this._addMovieToWatchListUseCase, this._removeMovieToWatchListUseCase);

  late final Movie movie;
  void setMovie(Movie movie) {
    this.movie = movie;
  }

  Future addMovieToWatchList() async {
    _addMovieToWatchListUseCase.execute(movie);
  }

  Future removeMovieToWatchList() async {
    _removeMovieToWatchListUseCase.execute(movie);
  }

  @override
  void dispose() {}
}
