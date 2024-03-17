import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/domain/usecases/usecases.dart';
import 'package:movies_app/presentation/base/state.dart';
import 'package:movies_app/presentation/modules/my_profile/my_profile_bloc.dart';

import 'my_profile_bloc_test.mocks.dart';

@GenerateMocks([FetchWatchListUseCase])
void main() {
  MockFetchWatchListUseCase fetchWatchListUseCase = MockFetchWatchListUseCase();
  late MyProfileBloC bloC;
  setUp(() {
    bloC = MyProfileBloC(fetchWatchListUseCase);
  });
  test('Test fetch watch list success', () async {
    // given
    List<Movie> movies = [
      Movie(id: "1"),
    ];
    // when
    when(fetchWatchListUseCase.execute())
        .thenAnswer((realInvocation) => Future.value(movies));
    bloC.getWatchListMovies();
    // then
    expect(
        bloC.watchListStream,
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
  test('Test fetch watch list success fail', () async {
    // given

    // when
    when(fetchWatchListUseCase.execute())
        .thenAnswer((realInvocation) => Future.error("Error"));
    bloC.getWatchListMovies();
    // then
    expect(
        bloC.watchListStream,
        emitsInOrder([
          predicate<AppState<List<Movie>>>((r) => r.isLoading),
          predicate<AppState<List<Movie>>>((r) => r.isError),
        ]));
  });
}
