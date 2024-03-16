import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieRatingBar extends StatelessWidget {
  const MovieRatingBar({super.key, required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: rating,
      itemSize: 10.0,
      minRating: 1,
      glowRadius: 10.0,
      maxRating: 5,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ignoreGestures: true,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      ratingWidget: RatingWidget(
          full: Icon(
            Icons.star,
            color: Colors.yellow[600],
          ),
          half: Icon(
            Icons.star_half,
            color: Colors.yellow[600],
          ),
          empty: Icon(
            Icons.star,
            color: Colors.yellow[100],
          )),
      onRatingUpdate: (rating) {},
      updateOnDrag: false,
    );
  }
}
