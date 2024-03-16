import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';

class FetchMovieListUseCase {
  final MovieRepository _movieRepository;

  FetchMovieListUseCase(this._movieRepository);

  Future<List<Movie>> execute() {
    return _movieRepository.getMovies();
  }
}
