import 'package:flutter/material.dart';
import '../models/genre.dart'; // Import Genre model
import '../database/firestore_service.dart'; // Import your FirestoreService
import '../widgets/movie_card.dart'; // Import MovieCard
import '../models/movie.dart'; // Import Movie model

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FocusNode _focusNode;
  String? _selectedValue; // Variable to store selected dropdown value
  late Future<List<Genre>> _genresFuture; // Future to fetch genres
  late Future<List<Movie>> _moviesFuture; // Future to fetch movies
  final FirestoreService _firestoreService =
      FirestoreService(); // Instance of FirestoreService

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _genresFuture = _fetchGenres(); // Initialize future to fetch genres
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<Genre>> _fetchGenres() async {
    try {
      return await _firestoreService.getGenres();
    } catch (e) {
      print('Error fetching genres: $e');
      return []; // Return an empty list on error
    }
  }

  void _handleTap() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus(); // Unfocus keyboard if it's open
    }
  }

  void _onGenreSelected(String? genreName) {
    setState(() {
      _selectedValue = genreName;
      // Filter movies based on selected genre name
      if (genreName != null) {
        _moviesFuture = _firestoreService.getMoviesByGenreName(genreName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap, // Handle tap to unfocus keyboard
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder<List<Genre>>(
          future: _genresFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Genre> genres =
                  snapshot.data ?? []; // Get list of genres from snapshot

              if (genres.isEmpty) {
                return Center(child: Text('No genres available.'));
              }

              // Initialize selected value if not already set
              if (_selectedValue == null && genres.isNotEmpty) {
                _selectedValue =
                    genres.first.name; // Set to first genre name initially
                // Load movies based on the initial genre name
                _moviesFuture =
                    _firestoreService.getMoviesByGenreName(_selectedValue!);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        // Handle text field changes
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: DropdownButton<String>(
                      value: _selectedValue,
                      onChanged: _onGenreSelected,
                      items:
                          genres.map<DropdownMenuItem<String>>((Genre genre) {
                        return DropdownMenuItem<String>(
                          value: genre.name, // Use genre name as dropdown value
                          child: Text(
                              genre.name), // Display genre name in dropdown
                        );
                      }).toList(),
                      isExpanded: true, // Expand dropdown to full width
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Movie>>(
                      future: _moviesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<Movie> movies = snapshot.data ??
                              []; // Get list of movies from snapshot

                          if (movies.isEmpty) {
                            return Center(child: Text('No movies available.'));
                          }

                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Number of columns
                              childAspectRatio:
                                  0.7, // Aspect ratio of the items
                            ),
                            itemCount: movies.length,
                            itemBuilder: (context, index) {
                              return MovieCard(movies[
                                  index]); // Pass movie object to MovieCard
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
