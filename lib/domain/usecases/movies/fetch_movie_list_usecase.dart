import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';
import 'package:movies_app/presentation/modules/global/movie_manager.dart';

class FetchMovieListUseCase {
  final MovieRepository _movieRepository;
  final MovieManager _movieManager;
  FetchMovieListUseCase(this._movieRepository, this._movieManager);

  Future<List<Movie>> execute()  async{
    List<Movie> movies = await _movieRepository.getMovies();
    _movieManager.updateTempMovies(movies);
    return Future(() => movies);
  }
}
