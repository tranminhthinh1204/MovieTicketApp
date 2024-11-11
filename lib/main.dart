import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/movie.dart';
import 'models/user.dart';
import 'models/showtime.dart';
import 'models/genre.dart';
import 'widgets/bottom_appbar.dart';
import 'screens/home_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/manage_movies.dart';
import 'screens/manage_showtimes.dart';
import 'screens/manage_tickets.dart';
import 'screens/manage_users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _loadGenresToFirebase(); // Đưa dữ liệu thể loại lên Firebase
  await _loadSampleUsersToFirebase(); // Đưa dữ liệu người dùng mẫu lên Firebase
  await _loadMoviesToFirebase();

  runApp(MyApp());
}

Future<void> _loadGenresToFirebase() async {
  await FirestoreService().addSampleGenres();
  print('Sample genres added to Firestore');
}

Future<void> _loadShowTimeToFirebase() async {
  await FirestoreService().addSampleShowtimes();
  print('Sample showtime added to Firestore');
}

Future<void> _loadMoviesToFirebase() async {
  await FirestoreService().addSampleMovies();
  print('Sample movies added to Firestore');
}

Future<void> _loadSampleUsersToFirebase() async {
  await FirestoreService().createSampleUsers();
  print('Sample users added to Firestore');
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = (prefs.getBool('isDarkMode') ?? false)
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  void _toggleThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return snapshot.data == true
                ? MainScreen(userId: '', toggleThemeMode: _toggleThemeMode)
                : LoginScreen();
          }
        },
      ),
      routes: {
        '/admin_dashboard': (context) => AdminDashboard(),
        '/manage_movies': (context) => ManageMoviesPage(),
        '/manage_showtimes': (context) => ManageShowtimesPage(),
        '/manage_users': (context) => ManageUsersPage(),
        '/manage_tickets': (context) => ManageTicketsPage(),
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

class MainScreen extends StatefulWidget {
  final String userId;
  final Function toggleThemeMode;

  MainScreen({required this.userId, required this.toggleThemeMode});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> _screens = [];
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userId: widget.userId),
      ScheduleScreen(),
      SearchScreen(),
      ProfileScreen(userId: widget.userId),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.toggleThemeMode();
        },
        child: Icon(Icons.brightness_6),
      ),
    );
  }
}
