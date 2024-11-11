import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moviebookingapp/app_colors.dart';
import 'package:moviebookingapp/database/firestore_service.dart';
import 'package:moviebookingapp/widgets/addMovieWidget.dart';

import '../../../models/genre.dart';
import '../../../models/movie.dart';

class ManageMoviesPage extends StatefulWidget {
  const ManageMoviesPage({super.key});

  @override
  State<ManageMoviesPage> createState() => _ManageMoviesPageState();
}

class _ManageMoviesPageState extends State<ManageMoviesPage> {
  List<Movie> data = [];
  List<String> genres = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchGener() ;
  }

  Future<void> fetchData() async {
    data.clear();
    List<Movie> movies = await FirestoreService().getMovies();
    setState(() {
      // Update state with the fetched data
      data.addAll(movies);
    });
    print('data size: ${movies.length}');
  }

  void fetchGener() async {
    List<Genre> genreData =  await FirestoreService().getGenres();
    genres = genreData.map((genre) => genre.name).toList();
    print('genres size: ${genres.length}');
  }

  void _addMovie({Movie? movie}) async {
    showBottomSheet(
        context: context,
        builder: (c) {
          return AddMovieWidget(callback: (type, data) {
            if (type == 'EDIT') {
              _readyEditMovie(data);
            }else {
              _readyAddMovie(data);
            }
          }, genres: genres, movie: movie,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: (data.length == 0)
                ? Center(
                    child: Text('Không có dữ liệu'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      Movie movie = data[index];
                      return _itemMovieWidget(movie);
                    }),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,

            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  _addMovie();
                },
                child: Text('Thêm dữ liệu')),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _itemMovieWidget(Movie movie) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.imageUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.fill,
                  errorBuilder: (context, exception, stackTrace) {
                    return Container(
                      width: 80,
                      height: 100,
                      child: Center(child: Text('Can\'t load image')),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${movie.title}',
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('${movie.genres.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                    Text('${movie.Director}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),

                    SizedBox(height: 5,),
                    Text('description: ${movie.description}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              SizedBox(
                width: 35,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            _addMovie(movie: movie);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            _readyRemoveMovie(movie);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.orangeAccent,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _readyAddMovie(Movie movie) async {
    await FirestoreService().addMovies(movie);
    Navigator.pop(context);
    fetchData();
  }

  void _readyEditMovie(Movie newMovie) async {
    await FirestoreService().updateMovie(newMovie);
    Navigator.pop(context);
    fetchData();
  }

  void _readyRemoveMovie(Movie newMovie) async {
    await FirestoreService().deleteMovie(newMovie.id);
    fetchData();
  }
}

