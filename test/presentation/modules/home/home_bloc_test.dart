import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/domain/usecases/usecases.dart';
import 'package:movies_app/presentation/base/state.dart';
import 'package:movies_app/presentation/modules/home/home_bloc.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([FetchMovieListUseCase])
void main() {
  MockFetchMovieListUseCase fetchMovieListUseCase = MockFetchMovieListUseCase();
  late HomeBloC bloC;
  setUp(() {
    bloC = HomeBloC(fetchMovieListUseCase);
  });

  test('Test fetch movie list success', () async {
    // given
    List<Movie> movies = [
      Movie(id: "1"),
    ];
    // when
    when(fetchMovieListUseCase.execute())
        .thenAnswer((realInvocation) => Future.value(movies));
    bloC.getMovies();
    // then
    expect(
        bloC.moviesStream,
        emitsInOrder([
          predicate<AppState<List<Movie>>>((r) => r.isLoading),
          predicate<AppState<List<Movie>>>(
            (r) =>
                r.isSuccess &&
                (r.data?.length ?? 0) == movies.length &&
                r.data?[0].id == "1",
          ),
        ]));
  });
  test('Test fetch movie list success fail', () async {
    // given

    // when
    when(fetchMovieListUseCase.execute())
        .thenAnswer((realInvocation) => Future.error("Error"));
    bloC.getMovies();
    // then
    expect(
        bloC.moviesStream,
        emitsInOrder([
          predicate<AppState<List<Movie>>>((r) => r.isLoading),
          predicate<AppState<List<Movie>>>((r) => r.isError),
        ]));
  });
}
