import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';
import '../app_colors.dart';
import '../database/firestore_service.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;

  MovieCard(this.movie);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isHovered = false;

  void _navigateToMovieDetail() async {
    Movie movieDetail = await FirestoreService().getMovieById(widget.movie.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MovieDetailScreen(movieDetail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: _navigateToMovieDetail,
          child: Stack(
            children: [
              Image.network(
                widget.movie.imageUrl,
                width: 150,
                height: 250,
                fit: BoxFit.cover,
              ),
              if (_isHovered)
                Container(
                  width: 150,
                  height: 200,
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _setHovered(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
