import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviebookingapp/widgets/bottom_appbar.dart';
import '../models/movie.dart';
import '../widgets/movies_list.dart';
import '../app_colors.dart';
import '../database/firestore_service.dart';
import '../models/genre.dart';
import '../screens/login_screen.dart';
import '../models/user.dart' as AppUser;
import '../screens/profile_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/search_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<AppUser.User?> _userFuture;
  int _currentIndex = 0;
  bool _isLoggedIn = false;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _userFuture = FirestoreService().getUserById(widget.userId);
    _checkLoginStatus();
    _pageController = PageController(
      viewportFraction:
          0.5, // Adjust viewportFraction to show more of adjacent items
      initialPage: 0,
    );

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage == 5) {
          // Assuming 5 items in the genre list for example
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _checkLoginStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _isLoggedIn = user != null;
      });
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trang Chủ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          FutureBuilder<AppUser.User?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;
                return Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userId: widget.userId),
                          ),
                        );
                      },
                      child: Text(
                        user.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: _logout,
                    ),
                  ],
                );
              } else {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Đăng nhập',
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeScreen(context),
          ScheduleScreen(),
          SearchScreen(),
          ProfileScreen(userId: widget.userId),
        ],
      ),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: FirestoreService().getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No movies available.'));
        } else {
          List<Movie> movies = snapshot.data!;
          return FutureBuilder<List<Genre>>(
            future: FirestoreService().getGenres(),
            builder: (context, genreSnapshot) {
              if (genreSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (genreSnapshot.hasError) {
                return Center(child: Text('Error: ${genreSnapshot.error}'));
              } else if (!genreSnapshot.hasData ||
                  genreSnapshot.data!.isEmpty) {
                return Center(child: Text('No genres available.'));
              } else {
                List<Genre> genres = genreSnapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CarouselSlider(
                        items: [
                          'lib/images/h3.jpg',
                          'lib/images/h4.jpg',
                        ].map((imagePath) {
                          return Container(
                            margin: EdgeInsets.all(6.0),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.5,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                        ),
                      ),
                      _buildMovieSections(movies, genres),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildMovieSections(List<Movie> movies, List<Genre> genres) {
    Map<String, List<Movie>> moviesByGenre = {};

    genres.forEach((genre) {
      moviesByGenre[genre.name] = [];
    });

    movies.forEach((movie) {
      movie.genres.forEach((genreName) {
        if (moviesByGenre.containsKey(genreName)) {
          moviesByGenre[genreName]!.add(movie);
        }
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: moviesByGenre.entries.map((entry) {
        if (entry.key == genres.first.name) {
          return _buildHorizontalScrollSection(entry.key, entry.value);
        }
        return _buildMovieSection(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildHorizontalScrollSection(String title, List<Movie> movies) {
    return Container(
      color: const Color.fromARGB(255, 254, 254, 255),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.Title,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeInOut.transform(value) * 250,
                        width: Curves.easeInOut.transform(value) * 200,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MovieList([movies[index]]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSection(String title, List<Movie> movies) {
    return Container(
      color: const Color.fromARGB(255, 254, 254, 255),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.Title,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 210,
            child: MovieList(movies),
          ),
        ],
      ),
    );
  }
}
