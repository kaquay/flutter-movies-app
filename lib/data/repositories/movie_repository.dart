import 'package:movies_app/data/datasources/remote/rest_client.dart';
import 'package:movies_app/data/models/movie.dart';
import 'dart:convert';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();
}

class MovieRepositoryImpl extends MovieRepository {
  final RestClient _restClient;

  MovieRepositoryImpl(this._restClient);

  @override
  Future<List<Movie>> getMovies() {
    return _restClient.getMovies().then((res) {
        List<dynamic> objects = jsonDecode(res);
        return objects.map((e) => Movie.fromJson(e)).toList();
    });
  }
}
