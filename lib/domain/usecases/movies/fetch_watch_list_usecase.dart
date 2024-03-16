import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/modules/global/movie_manager.dart';

class FetchWatchListUseCase {
  final MovieManager _movieManager;
  FetchWatchListUseCase(this._movieManager);

  Future<List<Movie>> execute()  async{
    List<Movie> movies = _movieManager.getWatchList();
    return Future(() => movies);
  }
}
