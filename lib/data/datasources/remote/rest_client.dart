import 'package:movies_app/data/models/movie.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://raw.githubusercontent.com/FEND16/movie-json-data/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('master/json/movies-coming-soon.json')
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
  })
  Future<String> getMovies();
}
