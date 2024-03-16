import 'dart:async';

import 'package:movies_app/data/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MovieManager {
  void updateTempMovies(List<Movie> movies);

  List<Movie> getWatchList();

  Future addToWatchList(Movie movie);

  Future removeWatchList(Movie movie);

  Stream<List<Movie>> watchListStream();

  Stream<Movie> movieEventStream();

  bool isAddedToWatchList(Movie movie);

  void dispose();
}

const kWatchListKey = "key-watch-list";

class MovieManagerImpl extends MovieManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final StreamController<List<Movie>> _watchListStream =
      StreamController.broadcast();
  final StreamController<Movie> _movieEventStream =
      StreamController.broadcast();
  List<Movie> tempMovies = [];
  List<String> watchIds = [];
  List<Movie> watchList = [];

  MovieManagerImpl() {
    _retrieDataFromPref();
  }

  void _retrieDataFromPref() async {
    final SharedPreferences prefs = await _prefs;
    watchIds = prefs.getStringList(kWatchListKey) ?? [];
  }

  Future _saveWatchListIds() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList(kWatchListKey, watchIds);
  }

  void _notifyWatchList() {
    _watchListStream.add(watchList);
  }

  @override
  void updateTempMovies(List<Movie> movies) {
    tempMovies = movies;
    watchList.clear();
    for (var movie in tempMovies) {
      if (watchIds.contains(movie.id)) {
        watchList.add(movie);
      }
    }
    _notifyWatchList();
  }

  @override
  List<Movie> getWatchList() {
    return watchList;
  }

  @override
  Future addToWatchList(Movie movie) async {
    if (isAddedToWatchList(movie)) {
      return;
    }
    // we ignore case movie not in tempMovies
    watchIds.add(movie.id ?? '');
    watchList.add(movie);
    await _saveWatchListIds();
    _movieEventStream.add(movie);
    _notifyWatchList();
  }

  @override
  Future removeWatchList(Movie movie) async {
    if (isAddedToWatchList(movie)) {
      // we ignore case movie not in tempMovies
      watchIds.removeWhere((id) => id == movie.id);
      watchList.removeWhere((m) => m.id == movie.id);
      await _saveWatchListIds();
      _movieEventStream.add(movie);
      _notifyWatchList();
    }
  }

  @override
  Stream<Movie> movieEventStream() {
    return _movieEventStream.stream;
  }

  @override
  Stream<List<Movie>> watchListStream() {
    return _watchListStream.stream;
  }

  @override
  void dispose() {
    _watchListStream.close();
    _movieEventStream.close();
  }

  @override
  bool isAddedToWatchList(Movie movie) {
    return watchIds.contains(movie.id);
  }
}
