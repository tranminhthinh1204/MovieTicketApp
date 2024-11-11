import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_colors.dart';
import '../../../models/movie.dart';
import '../../../models/showtime.dart';

class AddShowTimesWidget extends StatefulWidget {

  final Function callback;
  final Showtime? showtime;
  List<Movie> movies = [];


  AddShowTimesWidget({super.key, required this.callback, required this.movies, this.showtime});

  @override
  State<AddShowTimesWidget> createState() => _AddShowTimesWidgetState();
}

class _AddShowTimesWidgetState extends State<AddShowTimesWidget> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  TextEditingController stidController = TextEditingController();
  TextEditingController theaterIdController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool isEdit = false;
  Movie? selectedMovie;

  String movieID = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // stidController.text = '';
    // movieIdController.text = '';
    // theaterIdController.text = '';
    // startTimeController.text = '';
    // endTimeController.text = '';
    // dateController.text = '';

    startTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    endTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    dateController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    if (widget.showtime != null) {
      isEdit = true;
      stidController.text = widget.showtime!.stid;
      movieID = widget.showtime!.movieId;
      theaterIdController.text = widget.showtime!.theaterId;
      try {
        startTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(widget.showtime!.startTime);
        endTimeController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(widget.showtime!.endTime);
        dateController.text =
            DateFormat('yyyy-MM-dd HH:mm').format(widget.showtime!.date);

        for (var i in widget.movies) {
          if (movieID == i.id) {
            selectedMovie = i;
            break;
          }
        }

      } catch (e) {}
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.admin_color,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                isEdit ? 'Sửa dữ liệu' : 'Thêm dữ liệu',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chọn phim:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'BeVietnamPro', fontSize: 16)),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: AppColors.admin_color1,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: DropdownButton<Movie>(
                        isExpanded: true,
                        hint: Text('Select Movie'),
                        value: selectedMovie,
                        onChanged: (Movie? newValue) {
                          setState(() {
                            selectedMovie = newValue;
                            movieID = newValue?.id ?? '';
                          });
                        },
                        items: widget.movies.map<DropdownMenuItem<Movie>>((Movie movie) {
                          return DropdownMenuItem<Movie>(
                            value: movie,
                            child: Text(movie.title),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isEdit
                ? Container(
              alignment: Alignment.centerLeft,
                  child: Text('ShowTimeID: ${stidController.text}', style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16, fontFamily: 'BeVietnamPro'
                              ), textAlign: TextAlign.start,),
                )
                : TextField(
              textAlign: TextAlign.start,
              controller: stidController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'stid',
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: theaterIdController,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'theaterId',
                ),
              ),
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: startTimeController,
              maxLength: 16,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'startTime',
                ),
              ),
              onChanged: (value) {
                _handleDateInput(value, 0);
              },
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: endTimeController,
              keyboardType: TextInputType.datetime,
              maxLength: 16,
              decoration: const InputDecoration(
                // border: B,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'endTime',
                ),
              ),
              onChanged: (value) {
                _handleDateInput(value, 1);
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              textAlign: TextAlign.start,
              controller: dateController,
              keyboardType: TextInputType.datetime,
              maxLength: 16,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                alignLabelWithHint: true,
                label: Text(
                  'date',
                ),
              ),
              onChanged: (value) {
                _handleDateInput(value, 2);
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () {
                    if (startTimeController.text == '' ||
                        endTimeController.text == '' ||
                        stidController.text == '' ||
                        theaterIdController.text == '' ||
                        dateController.text == '') {
                      return;
                    }
                    Showtime newShowtime = Showtime(
                        stid: stidController.text,
                        movieId: movieID,
                        theaterId: theaterIdController.text,
                        startTime: DateFormat('yyyy-MM-dd HH:mm').parse(startTimeController.text),
                        endTime: DateFormat('yyyy-MM-dd HH:mm').parse(endTimeController.text),
                        date: DateFormat('yyyy-MM-dd HH:mm').parse(dateController.text));

                    (isEdit == true) ? widget.callback('EDIT', newShowtime) : widget.callback('ADD', newShowtime);

                    // isEdit
                    //     ? _readyEditShowtime(newShowtime)
                    //     : _readyAddShowtime(newShowtime);
                  },
                  child: Text('Đồng ý')),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDateInput(String value, int type) {
    try {
      // Remove any non-digit characters and check if we have 8 digits (ddMMyyyy)
      String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length == 8) {
        // Format the input as dd/MM/yyyy
        String formatted =
            '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2, 4)}/${digitsOnly.substring(4, 8)}';
        DateTime date = dateFormat.parse(formatted);

        if (type == 0) {
          startTimeController.value = TextEditingValue(
            text: dateFormat.format(date),
            selection: TextSelection.fromPosition(
              TextPosition(offset: dateFormat.format(date).length),
            ),
          );
        } else if (type == 1) {
          endTimeController.value = TextEditingValue(
            text: dateFormat.format(date),
            selection: TextSelection.fromPosition(
              TextPosition(offset: dateFormat.format(date).length),
            ),
          );
        } else {
          dateController.value = TextEditingValue(
            text: dateFormat.format(date),
            selection: TextSelection.fromPosition(
              TextPosition(offset: dateFormat.format(date).length),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any parsing errors if needed
    }
  }

}
