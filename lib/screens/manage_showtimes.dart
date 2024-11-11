import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviebookingapp/app_colors.dart';
import 'package:moviebookingapp/widgets/addShowtimesWidget.dart';

import '../../../database/firestore_service.dart';
import '../../../models/movie.dart';
import '../../../models/showtime.dart';

class ManageShowtimesPage extends StatefulWidget {
  const ManageShowtimesPage({super.key});

  @override
  State<ManageShowtimesPage> createState() => _ManageShowtimesPageState();
}

class _ManageShowtimesPageState extends State<ManageShowtimesPage> {
  List<Showtime> data = [];
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchMovie();
  }

  Future<void> fetchData() async {
    data.clear();
    List<Showtime> showtimes = await FirestoreService().getShowtimes();
    setState(() {
      // Update state with the fetched data
      data.addAll(showtimes);
    });
    print('data size: ${showtimes.length}');
  }

  Future<void> fetchMovie() async {
    movies = await FirestoreService().getMovies();
    print('data size: ${movies.length}');
  }

  void _addShowtime({Showtime? showtime}) async {
    showBottomSheet(
        context: context,
        builder: (c) {
          return AddShowTimesWidget(callback: (type, data) {
            if (type == 'EDIT') {
              _readyEditShowtime(data);
            }else {
              _readyAddShowtime(data);
            }
          }, movies: movies, showtime: showtime,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      Showtime showtime = data[index];
                      return _itemShowtimeWidget(showtime);
                    }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  _addShowtime();
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

  Widget _itemShowtimeWidget(Showtime showtime) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        // color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('stid: ${showtime.stid}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text('movieId: ${showtime.movieId}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text('theaterId: ${showtime.theaterId}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text(
                        'startTime: ${DateFormat('yyyy-MM-dd HH:mm').format(showtime.startTime)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text(
                        'endTime: ${DateFormat('yyyy-MM-dd HH:mm').format(showtime.endTime)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                    Text(
                        'date: ${DateFormat('yyyy-MM-dd HH:mm').format(showtime.date)}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BeVietnamPro')),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            _addShowtime(showtime: showtime);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            _readyRemoveShowtime(showtime);
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

  void _readyAddShowtime(Showtime showtime) async {
    await FirestoreService().addShowtimes(showtime);
    Navigator.pop(context);
    fetchData();
  }

  void _readyEditShowtime(Showtime newShowtime) async {
    await FirestoreService().updateShowtimes(newShowtime);
    Navigator.pop(context);
    fetchData();
  }

  void _readyRemoveShowtime(Showtime newShowtime) async {
    await FirestoreService().deleteShowtimes(newShowtime.stid);
    fetchData();
  }
}
