
// import 'package:flutter/material.dart';
// import '../models/movie.dart';
// import '../models/showtime.dart';
// import '../database/firestore_service.dart';

// class ScheduleScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: FutureBuilder<List<Showtime>>(
//         future: FirestoreService().getShowtimes(),
//         builder: (context, showtimeSnapshot) {
//           if (showtimeSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (showtimeSnapshot.hasError) {
//             return Center(child: Text('Error: ${showtimeSnapshot.error}'));
//           } else if (!showtimeSnapshot.hasData || showtimeSnapshot.data!.isEmpty) {
//             return Center(child: Text('No showtimes available.'));
//           } else {
//             List<Showtime> showtimes = showtimeSnapshot.data!;
//             return FutureBuilder<List<Movie>>(
//               future: FirestoreService().getMovies(),
//               builder: (context, movieSnapshot) {
//                 if (movieSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (movieSnapshot.hasError) {
//                   return Center(child: Text('Error: ${movieSnapshot.error}'));
//                 } else if (!movieSnapshot.hasData || movieSnapshot.data!.isEmpty) {
//                   return Center(child: Text('No movies available.'));
//                 } else {
//                   List<Movie> movies = movieSnapshot.data!;
//                   return Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Lịch chiếu phim',
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 20),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: showtimes.length,
//                             itemBuilder: (context, index) {
//                               Showtime showtime = showtimes[index];
//                               Movie? movie = movies.firstWhere((movie) => movie.id == showtime.movieId, orElse: () => Movie(id: '', title: '', genres: [], description: '', imageUrl: '', Director: '',videoUrl:''));
                              
//                               return Card(
//                                 margin: EdgeInsets.symmetric(vertical: 10),
//                                 child: ListTile(
//                                   title: Text(movie.title),
//                                   subtitle: Text('Showing Time: ${showtime.startTime.hour}:${showtime.startTime.minute} - ${showtime.endTime.hour}:${showtime.endTime.minute}'),
//                                   trailing: Icon(Icons.movie),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../database/firestore_service.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isCalendarVisible = false;
  List<Showtime> _showtimes = [];
  List<Movie> _movies = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Showtime> showtimes = await FirestoreService().getShowtimes();
      List<Movie> movies = await FirestoreService().getMovies();
      setState(() {
        _showtimes = showtimes;
        _movies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  List<Showtime> _getShowtimesForSelectedDay() {
    if (_selectedDay == null) return [];
    return _showtimes.where((showtime) {
      return showtime.date.year == _selectedDay!.year &&
          showtime.date.month == _selectedDay!.month &&
          showtime.date.day == _selectedDay!.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isError) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error loading data')),
      );
    }

    List<Showtime> showtimesForSelectedDay = _getShowtimesForSelectedDay();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lịch chiếu phim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isCalendarVisible = !_isCalendarVisible;
                  });
                },
                icon: Icon(Icons.calendar_today),
                label: Text(_isCalendarVisible ? 'Ẩn lịch' : 'Chọn ngày'),
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: _isCalendarVisible,
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _isCalendarVisible = false; // Collapse the calendar after selection
                  });
                },
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
              ),
            ),
            SizedBox(height: 20),
            if (showtimesForSelectedDay.isEmpty)
              Center(child: Text('Không có lịch chiếu nào trong ngày hôm nay.')),
            if (showtimesForSelectedDay.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: showtimesForSelectedDay.length,
                  itemBuilder: (context, index) {
                    Showtime showtime = showtimesForSelectedDay[index];
                    Movie? movie = _movies.firstWhere(
                      (movie) => movie.id == showtime.movieId,
                      orElse: () => Movie(
                          id: '', title: '', genres: [], description: '', imageUrl: '', Director: '', videoUrl: ''),
                    );

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(movie.title),
                        subtitle: Text(
                            'Showing Time: ${showtime.startTime.hour}:${showtime.startTime.minute} - ${showtime.endTime.hour}:${showtime.endTime.minute}'),
                        trailing: Icon(Icons.movie),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
