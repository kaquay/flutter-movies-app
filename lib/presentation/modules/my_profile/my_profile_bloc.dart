import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/domain/usecases/usecases.dart';
import 'package:movies_app/presentation/base/base_bloc.dart';
import 'package:movies_app/presentation/base/state.dart';
import 'package:movies_app/presentation/modules/my_profile/auth/google_signin.dart';

class MyProfileBloC extends BloC {
  final FetchWatchListUseCase _fetchWatchListUseCase;

  MyProfileBloC(
    this._fetchWatchListUseCase,
  );

  final StreamController<AppState<List<Movie>>> _watchListStreamController =
      StreamController();
  Stream<AppState<List<Movie>>> get watchListStream =>
      _watchListStreamController.stream;

  Future googleSignIn() {
    return signInWithGoogle();
  }

  Future logoutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }

  Future getWatchListMovies() async {
    _watchListStreamController.add(AppState.loading());
    try {
      List<Movie> movies = await _fetchWatchListUseCase.execute();
      _watchListStreamController.add(AppState.success(movies));
    } catch (e) {
      _watchListStreamController.add(AppState.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _watchListStreamController.close();
  }
}
