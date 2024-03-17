import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/domain/usecases/usecases.dart';
import 'package:movies_app/presentation/modules/movie_detail/movie_detail_bloc.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([AddMovieToWatchListUseCase, RemoveMovieToWatchListUseCase])
void main() {
  late MovieDetailBloC bloC;
  MockAddMovieToWatchListUseCase addMovieToWatchListUseCase =
      MockAddMovieToWatchListUseCase();
  MockRemoveMovieToWatchListUseCase removeMovieToWatchListUseCase =
      MockRemoveMovieToWatchListUseCase();
  Movie movie = Movie(id: "1");
  setUp(() {
    bloC = MovieDetailBloC(
        addMovieToWatchListUseCase, removeMovieToWatchListUseCase);
    bloC.setMovie(movie);
  });
  test('verify addMovieToWatchListUseCase call', () async {
    when(addMovieToWatchListUseCase.execute(movie))
        .thenAnswer((realInvocation) => Future.value());
    bloC.addMovieToWatchList();
    verify(addMovieToWatchListUseCase.execute(movie)).called(1);
  });
  test('verify removeMovieToWatchListUseCase call', () async {
    when(removeMovieToWatchListUseCase.execute(movie))
        .thenAnswer((realInvocation) => Future.value());
    bloC.removeMovieToWatchList();
    verify(removeMovieToWatchListUseCase.execute(movie)).called(1);
  });
}
