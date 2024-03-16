import 'package:flutter/material.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/base/state.dart';
import 'package:movies_app/presentation/modules/global/widgets/error_widget.dart';
import 'package:movies_app/presentation/modules/home/home_bloc.dart';
import 'package:movies_app/presentation/modules/home/widgets/item_movie.dart';
import 'package:movies_app/presentation/modules/home/widgets/profile_avatar.dart';
import 'package:movies_app/presentation/modules/movie_detail/movie_detail_module.dart';
import 'package:movies_app/presentation/modules/my_profile/my_profile_module.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBloC bloC = Provider.of<HomeBloC>(context);
    bloC.getMovies();
    ThemeData theme = Theme.of(context);
    Color appBackground = theme.colorScheme.background;
    String title = "Movie List";
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBackground,
        actions: [
          ProfileAvatar(
            onPressed: (user) {
              openProfile(context);
            },
          ),
        ],
      ),
      body: Container(
        child: _buildListMovie(context),
      ),
    );
  }

  Widget _buildListMovie(BuildContext context) {
    HomeBloC bloC = Provider.of<HomeBloC>(context);
    String errorMessage = "Please check your network";
    String errorAction = "Try again";
    return StreamBuilder<AppState<List<Movie>>>(
      stream: bloC.moviesStream,
      initialData: AppState.loading(),
      builder: ((context, snapshot) {
        var state = snapshot.requireData;
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.isError) {
          return Container(
            margin: const EdgeInsets.only(top: 200.0),
            height: 250.0,
            child: AppErrorWidget.simple(errorMessage, errorAction, () {
              bloC.getMovies();
            }),
          );
        }
        if (state.isSuccess) {
          List<Movie> items = snapshot.requireData.data ?? [];
          return ListView.builder(
            itemBuilder: (context, index) {
              return MovieItem(
                movie: items[index],
                callback: (movie) {
                  openMovieDetail(context, movie);
                },
              );
            },
            itemCount: items.length,
          );
        }
        return Container();
      }),
    );
  }
}
