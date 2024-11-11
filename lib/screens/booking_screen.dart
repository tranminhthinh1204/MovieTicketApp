
// import 'package:flutter/material.dart';
// import '../models/movie.dart';
// import '../models/showtime.dart';
// import '../models/ticket.dart'; // Import the Ticket model
// import '../database/firestore_service.dart';
// import 'success_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BookingScreen extends StatefulWidget {
//   final Movie movie;

//   BookingScreen(this.movie);

//   @override
//   _BookingScreenState createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   List<Showtime> showtimes = [];
//   List<Ticket> bookedTickets = [];
//   DateTime? _selectedDate;
//   String? _selectedTime;
//   List<String> selectedSeats = [];
//   double _ticketPrice = 70.000; // Giả sử giá vé mặc định là 70,000 VND

//   @override
//   void initState() {
//     super.initState();
//     _fetchShowtimes();
//   }

//   Future<void> _fetchShowtimes() async {
//     List<Showtime> fetchedShowtimes = await FirestoreService().getShowtimesByMovieId(widget.movie.id);
//     setState(() {
//       showtimes = fetchedShowtimes;
//     });
//   }

//   Future<void> _fetchBookedTickets(String showtimeId) async {
//     List<Ticket> fetchedTickets = await FirestoreService().getTicketsByShowtimeId(showtimeId);
//     setState(() {
//       bookedTickets = fetchedTickets;
//     });
//   }

//   // Tính giá vé cho từng ghế
//   double _calculateTicketPrice() {
//     return selectedSeats.length * _ticketPrice;
//   }

//   void _toggleSelectedSeat(String seat) {
//     setState(() {
//       if (selectedSeats.contains(seat)) {
//         selectedSeats.remove(seat);
//       } else {
//         selectedSeats.add(seat);
//       }
//     });
//   }

//   Future<void> _bookTickets() async {
//     // Lấy userId từ SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('userId');

//     if (userId == null) {
//       // Nếu không tìm thấy userId, bạn có thể hiển thị thông báo lỗi hoặc xử lý theo cách khác
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User not logged in')),
//       );
//       return;
//     }

//     String showtimeId = showtimes.firstWhere((showtime) =>
//         showtime.date.day == _selectedDate!.day &&
//         DateFormat.jm().format(showtime.startTime) == _selectedTime).stid;

//     List<Future<void>> ticketFutures = selectedSeats.map((seat) {
//       String ticketId = Uuid().v4();
//       Ticket ticket = Ticket(
//         tkid: ticketId,
//         movieId: widget.movie.id,
//         userId: userId, // Sử dụng userId thực tế từ SharedPreferences
//         stid: showtimeId,
//         seatNumber: seat,
//       );
//       return FirestoreService().addTicket(ticket);
//     }).toList();

//     await Future.wait(ticketFutures);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Book Tickets for ${widget.movie.title}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.movie.title,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               if (showtimes.isNotEmpty) ...[
//                 Text('Select Date'),
//                 Container(
//                   height: 60,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: showtimes.length,
//                     itemBuilder: (context, index) {
//                       DateTime date = showtimes[index].date;
//                       bool isSelected = _selectedDate != null && _selectedDate!.day == date.day;
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _selectedDate = date;
//                             _selectedTime = null; // Reset selected time when date changes
//                           });
//                         },
//                         child: Container(
//                           margin: EdgeInsets.symmetric(horizontal: 8),
//                           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                           decoration: BoxDecoration(
//                             color: isSelected ? Colors.blue : Colors.grey.shade300,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 DateFormat.E().format(date), // Hiển thị thứ
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                               Text(
//                                 DateFormat.d().format(date), // Hiển thị ngày
//                                 style: TextStyle(
//                                   color: isSelected ? Colors.white : Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 if (_selectedDate != null) ...[
//                   Text('Select Time'),
//                   DropdownButtonFormField<String>(
//                     hint: Text('Select Time'),
//                     value: _selectedTime,
//                     items: showtimes
//                         .where((showtime) => showtime.date.day == _selectedDate!.day)
//                         .map((showtime) {
//                           String time = DateFormat.jm().format(showtime.startTime);
//                           return DropdownMenuItem<String>(
//                             value: time,
//                             child: Text(time),
//                           );
//                         }).toList(),
//                     onChanged: (value) async {
//                       setState(() {
//                         _selectedTime = value;
//                       });
//                       if (value != null) {
//                         String showtimeId = showtimes.firstWhere((showtime) =>
//                             showtime.date.day == _selectedDate!.day &&
//                             DateFormat.jm().format(showtime.startTime) == value).stid;
//                         await _fetchBookedTickets(showtimeId);
//                       }
//                     },
//                   ),
//                 ],
//                 SizedBox(height: 20),
//                 if (_selectedTime != null) ...[
//                   Text('Select Seat(s)'),
//                   Wrap(
//                     spacing: 10.0,
//                     runSpacing: 10.0,
//                     children: [
//                       'A1', 'A2', 'A3', 'A4', 'A5', 'A6',
//                       'B1', 'B2', 'B3', 'B4', 'B5', 'B6',
//                       'C1', 'C2', 'C3', 'C4', 'C5', 'C6',
//                       'D1', 'D2', 'D3', 'D4', 'D5', 'D6',
//                     ].map((seat) {
//                       bool isBooked = bookedTickets.any((ticket) => ticket.seatNumber == seat);
//                       bool isSelected = selectedSeats.contains(seat);
//                       return GestureDetector(
//                         onTap: isBooked ? null : () => _toggleSelectedSeat(seat),
//                         child: Chip(
//                           label: Text(seat),
//                           backgroundColor: isBooked
//                               ? Colors.red
//                               : isSelected
//                                   ? Colors.blue
//                                   : Colors.grey.shade300,
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 20),
//                   Text('Total Amount: \$${_calculateTicketPrice().toStringAsFixed(2)}'),
//                   SizedBox(height: 20),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (selectedSeats.isNotEmpty) {
//                           await _bookTickets();
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                               builder: (ctx) => SuccessScreen(),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Please select at least one seat!')),
//                           );
//                         }
//                       },
//                       child: Text('Book Now'),
//                     ),
//                   ),
//                 ],
//               ] else ...[
//                 Center(child: CircularProgressIndicator()),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../models/ticket.dart'; // Import the Ticket model
import '../database/firestore_service.dart';
import 'success_screen.dart';
import 'payment_screen.dart'; // Import the PaymentScreen
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingScreen extends StatefulWidget {
  final Movie movie;

  BookingScreen(this.movie);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Showtime> showtimes = [];
  List<Ticket> bookedTickets = [];
  DateTime? _selectedDate;
  String? _selectedTime;
  List<String> selectedSeats = [];
  double _ticketPrice = 70.000; // Giả sử giá vé mặc định là 70,000 VND

  @override
  void initState() {
    super.initState();
    _fetchShowtimes();
  }

  Future<void> _fetchShowtimes() async {
    List<Showtime> fetchedShowtimes = await FirestoreService().getShowtimesByMovieId(widget.movie.id);
    setState(() {
      showtimes = fetchedShowtimes;
    });
  }

  Future<void> _fetchBookedTickets(String showtimeId) async {
    List<Ticket> fetchedTickets = await FirestoreService().getTicketsByShowtimeId(showtimeId);
    setState(() {
      bookedTickets = fetchedTickets;
    });
  }

  // Tính giá vé cho từng ghế
  double _calculateTicketPrice() {
    return selectedSeats.length * _ticketPrice;
  }

  void _toggleSelectedSeat(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  Future<void> _bookTickets() async {
    // Lấy userId từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      // Nếu không tìm thấy userId, bạn có thể hiển thị thông báo lỗi hoặc xử lý theo cách khác
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    String showtimeId = showtimes.firstWhere((showtime) =>
        showtime.date.day == _selectedDate!.day &&
        DateFormat.jm().format(showtime.startTime) == _selectedTime).stid;

    List<Ticket> bookedTicketsToAdd = selectedSeats.map((seat) {
      String ticketId = Uuid().v4();
      return Ticket(
        tkid: ticketId,
        movieId: widget.movie.id,
        userId: userId, // Sử dụng userId thực tế từ SharedPreferences
        stid: showtimeId,
        seatNumber: seat,
      );
    }).toList();

    // Chuyển sang trang thanh toán và truyền các giá trị cần thiết
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PaymentScreen(
          tickets: bookedTicketsToAdd,
          totalAmount: _calculateTicketPrice(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Tickets for ${widget.movie.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (showtimes.isNotEmpty) ...[
                Text('Select Date'),
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: showtimes.length,
                    itemBuilder: (context, index) {
                      DateTime date = showtimes[index].date;
                      bool isSelected = _selectedDate != null && _selectedDate!.day == date.day;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                            _selectedTime = null; // Reset selected time when date changes
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.E().format(date), // Hiển thị thứ
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                DateFormat.d().format(date), // Hiển thị ngày
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                if (_selectedDate != null) ...[
                  Text('Select Time'),
                  DropdownButtonFormField<String>(
                    hint: Text('Select Time'),
                    value: _selectedTime,
                    items: showtimes
                        .where((showtime) => showtime.date.day == _selectedDate!.day)
                        .map((showtime) {
                      String time = DateFormat.jm().format(showtime.startTime);
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      setState(() {
                        _selectedTime = value;
                      });
                      if (value != null) {
                        String showtimeId = showtimes.firstWhere((showtime) =>
                        showtime.date.day == _selectedDate!.day &&
                            DateFormat.jm().format(showtime.startTime) == value).stid;
                        await _fetchBookedTickets(showtimeId);
                      }
                    },
                  ),
                ],
                SizedBox(height: 20),
                if (_selectedTime != null) ...[
                  Text('Select Seat(s)'),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      'A1', 'A2', 'A3', 'A4', 'A5', 'A6',
                      'B1', 'B2', 'B3', 'B4', 'B5', 'B6',
                      'C1', 'C2', 'C3', 'C4', 'C5', 'C6',
                      'D1', 'D2', 'D3', 'D4', 'D5', 'D6',
                    ].map((seat) {
                      bool isBooked = bookedTickets.any((ticket) => ticket.seatNumber == seat);
                      bool isSelected = selectedSeats.contains(seat);
                      return GestureDetector(
                        onTap: isBooked ? null : () => _toggleSelectedSeat(seat),
                        child: Chip(
                          label: Text(seat),
                          backgroundColor: isBooked
                              ? Colors.red
                              : isSelected
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text('Total Amount: \$${_calculateTicketPrice().toStringAsFixed(2)}'),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedSeats.isNotEmpty) {
                          await _bookTickets();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select at least one seat!')),
                          );
                        }
                      },
                      child: Text('Book Now'),
                    ),
                  ),
                ],
              ] else ...[
                Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
