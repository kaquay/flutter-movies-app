import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/base/state.dart';
import 'package:movies_app/presentation/modules/global/widgets/error_widget.dart';
import 'package:movies_app/presentation/modules/my_profile/my_profile_bloc.dart';
import 'package:movies_app/presentation/modules/my_profile/widgets/item_watch_list.dart';
import 'package:movies_app/presentation/modules/my_profile/widgets/single_value_line.dart';
import 'package:provider/provider.dart';

import '../movie_detail/movie_detail_module.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "Profile";
    ThemeData theme = Theme.of(context);
    Color appBackground = theme.colorScheme.background;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackground,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white,
        ),
        actions: [
          _buildLogOut(context),
        ],
      ),
      body: _buildFirebaseAuth(context),
    );
  }

  Widget _buildFirebaseAuth(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;
          if (user == null) {
            return _buildAuthList(context);
          } else {
            return _buildUserInfo(context, user);
          }
        });
  }

  Widget _buildWatchList(BuildContext context) {
    MyProfileBloC bloC = context.read<MyProfileBloC>();
    bloC.getWatchListMovies();
    String errorMessage = "Something went wrong.";
    String emptyMessage = "Empty List";
    return StreamBuilder<AppState<List<Movie>>>(
        stream: bloC.watchListStream,
        initialData: AppState.loading(),
        builder: (context, snapshot) {
          var state = snapshot.requireData;
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isError) {
            return Container(
              margin: const EdgeInsets.only(top: 200.0),
              height: 200.0,
              child: AppErrorWidget(
                image: const Icon(Icons.error),
                content: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          if (state.isSuccess) {
            List<Movie> items = snapshot.requireData.data ?? [];
            if (items.isEmpty) {
              return AppErrorWidget(
                image: const Icon(Icons.error),
                content: Text(
                  emptyMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return WatchListItem(
                  movie: items[index],
                  onPressed: (movie) {
                    openMovieDetail(context, movie)
                        .then((value) => bloC.getWatchListMovies());
                  },
                );
              },
              itemCount: items.length,
              separatorBuilder: (_, index) => const SizedBox(
                width: 8.0,
              ),
            );
          }
          return Container();
        });
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    String watchListTitle = "Watch list";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.photoURL ?? '',
              width: 100.0,
              height: 100.0,
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),
          SingleValueLine.text("Name ", user.displayName ?? ''),
          SingleValueLine.text("Email ", user.email ?? ''),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            watchListTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 200.0,
            child: _buildWatchList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLogOut(BuildContext context) {
    String action = "Sign Out";
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;
          if (user != null) {
            return TextButton(
                onPressed: () {
                  context.read<MyProfileBloC>().logoutGoogle();
                },
                child: Text(action));
          } else {
            return Container();
          }
        });
  }

  Widget _buildAuthList(BuildContext context) {
    String sectionTitle = "Auth providers";
    String errorMessage = "Something went wrong! Please try again.";
    String googleTitle = "google";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<MyProfileBloC>().googleSignIn().catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                  ),
                );
                return error;
              });
            },
            child: Text(googleTitle),
          ),
        ],
      ),
    );
  }
}
