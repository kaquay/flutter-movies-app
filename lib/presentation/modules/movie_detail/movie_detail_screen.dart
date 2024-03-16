import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/modules/global/widgets/movie_rating_bar.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: _buildBackgroundImage(context),
          ),
          Positioned(
            top: 50.0,
            left: 0.0,
            right: 0.0,
            child: _buildBar(context),
          ),
          Positioned(
            top: 200,
            left: 0.0,
            right: 0.0,
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 30.0,
          bottom: 0.0,
          right: 10.0,
          left: 10.0,
          child: _buildContentBackgroundCard(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: "poster",
                    child: CachedNetworkImage(
                      imageUrl: movie.posterurl ?? '',
                      placeholder: (context, url) =>
                          Container(color: Colors.grey),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      width: 120.0,
                      height: 200.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildMovieNameInfo(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              SizedBox(
                height: 400.0,
                child: ListView(
                  children: [
                    const Text(
                      'Introduce',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(movie.storyline ?? ''),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text(
                      'Actors',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(movie.actors?.join("\n") ?? ''),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMovieNameInfo(BuildContext context) {
    String title = movie.title ?? '';
    String genres = movie.genres?.join(" / ") ?? '';
    bool shouldShowImdbRating = movie.imdbRating != null;
    String imdbRating = "Imdb Rating: ${movie.imdbRating}";
    List<int> ratings = movie.ratings ?? <int>[];
    int totalPoint = ratings.fold(
            0, (previousValue, element) => (previousValue ?? 0) + element) ??
        0;
    double averageRating = totalPoint.toDouble() / ratings.length / 2;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
        Text(
          genres,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            fontStyle: FontStyle.italic,
          ),
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
        if (shouldShowImdbRating)
          Text(
            imdbRating,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
        const SizedBox(
          height: 30.0,
        ),
        Row(
          children: [
            MovieRatingBar(rating: averageRating),
            Text(
              averageRating.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.yellow,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildContentBackgroundCard(BuildContext context) {
    Color contentBgColor = Colors.grey;
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: contentBgColor,
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return const Row(
      children: [
        BackButton(
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            'Detail',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 50.0,
        ),
      ],
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    double blur = 3.0;
    return Container(
      height: 350.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            movie.posterurl ?? '',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          color: Colors.black.withOpacity(0.1),
        ),
      ),
    );
  }
}
