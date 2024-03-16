import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/modules/global/movie_manager.dart';

class AddMovieToWatchListUseCase {
  final MovieManager _movieManager;
  AddMovieToWatchListUseCase(this._movieManager);

  Future execute(Movie movie)  async{
    _movieManager.addToWatchList(movie);
  }
}
