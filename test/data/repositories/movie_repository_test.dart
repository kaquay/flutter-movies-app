import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies_app/data/datasources/remote/rest_client.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/data/repositories/movie_repository.dart';

import 'movie_repository_test.mocks.dart';

@GenerateMocks([RestClient])
void main() {
  MockRestClient restClient = MockRestClient();
  late MovieRepository repository;
  setUp(() {
    repository = MovieRepositoryImpl(restClient);
  });

  test('Test Repository parse correct data', () async {
    // given
    String json = '''
    [
      {
        "id": "1"
      }
    ]
    ''';
    // when
    when(restClient.getMovies())
        .thenAnswer((realInvocation) => Future.value(json));
    expect(
      await repository.getMovies(),
      predicate<List<Movie>>(
          (items) => items.length == 1 && items[0].id == "1"),
    );
  });
}
