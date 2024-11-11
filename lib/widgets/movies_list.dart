import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MovieCard(movies[index]),
          );
        },
      ),
    );
  }
}
