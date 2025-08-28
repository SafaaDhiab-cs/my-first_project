// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final Function(double)? onRatingChanged; // السماح بقيم null لتعطيله
  final int starCount;
  final Color color;

  const StarRating({
    Key? key,
    required this.rating,
    this.onRatingChanged,
    this.starCount = 5,
    this.color = Colors.amber, // لون افتراضي
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(starCount, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: color,
            size: 40,
          ),
          onPressed: onRatingChanged != null ? () => onRatingChanged!(index + 1.0) : null,
        );
      }),
    );
  }
}
