import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/modules/global/movie_manager.dart';

class RemoveMovieToWatchListUseCase {
  final MovieManager _movieManager;
  RemoveMovieToWatchListUseCase(this._movieManager);

  Future execute(Movie movie)  async{
    _movieManager.removeWatchList(movie);
  }
}
