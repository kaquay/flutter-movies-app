import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/data/models/movie.dart';

class WatchListItem extends StatelessWidget {
  const WatchListItem(
      {super.key, required this.movie, required this.onPressed});
  final Function(Movie movie) onPressed;
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(movie),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: CachedNetworkImage(
          imageUrl: movie.posterurl ?? '',
          height: 200,
          width: 140,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
