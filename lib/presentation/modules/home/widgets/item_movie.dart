import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/data/models/movie.dart';
import 'package:movies_app/presentation/modules/global/widgets/movie_rating_bar.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;
  final Function(Movie) callback;
  const MovieItem({super.key, required this.movie, required this.callback});

  @override
  Widget build(BuildContext context) {
    Color contentBgColor = Colors.grey;
    String title = movie.title ?? '';
    String genres = movie.genres?.join(" / ") ?? '';
    bool shouldShowImdbRating = movie.imdbRating != null;
    String imdbRating = "Imdb Rating: ${movie.imdbRating}";
    List<int> ratings = movie.ratings ?? <int>[];
    int totalPoint = ratings.fold(
            0, (previousValue, element) => (previousValue ?? 0) + element) ??
        0;
    double averageRating = totalPoint.toDouble() / ratings.length / 2;

    return InkWell(
      onTap: () {
        callback(movie);
      },
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              bottom: 0.0,
              right: 10.0,
              left: 10.0,
              child: Hero(
                tag: "background${movie.id}",
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: contentBgColor,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              bottom: 20.0,
              left: 40.0,
              child: Hero(
                tag: "poster${movie.id}",
                child: CachedNetworkImage(
                  imageUrl: movie.posterurl ?? '',
                  placeholder: (context, url) => Container(color: Colors.grey),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 140.0,
                  height: 200.0,
                ),
              ),
            ),
            Positioned(
                top: 80.0,
                bottom: 20.0,
                left: 200.0,
                right: 20.0,
                child: Column(
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
                )),
          ],
        ),
      ),
    );
  }
}
