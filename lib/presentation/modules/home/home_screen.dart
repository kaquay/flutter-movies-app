import 'package:flutter/material.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/modules/global/widgets/error_widget.dart';
import 'package:movies_app/presentation/modules/home/home_bloc.dart';
import 'package:movies_app/presentation/modules/home/widgets/item_movie.dart';
import 'package:movies_app/presentation/modules/movie_detail/movie_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/presentation/base/state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloC _bloC;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloC = Provider.of<HomeBloC>(context);
    _bloC.getMovies();
    ThemeData theme = Theme.of(context);
    Color appBackground = theme.colorScheme.background;
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(
        title: const Text(
          'Movie List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBackground,
      ),
      body: Container(
        child: _buildListMovie(context),
      ),
    );
  }

  Widget _buildListMovie(BuildContext context) {
    _bloC = Provider.of<HomeBloC>(context);
    return StreamBuilder<AppState<List<Movie>>>(
      stream: _bloC.moviesStream,
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
            child: AppErrorWidget.simple(
                "Please check your network", "Try again", () {
              _bloC.getMovies();
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(movie: movie),
                    ),
                  );
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

  @override
  void dispose() {
    super.dispose();
    _bloC.dispose();
  }
}
