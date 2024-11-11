import 'package:flutter/material.dart';
import '../models/ticket.dart';
import '../database/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  List<Ticket> tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      List<Ticket> fetchedTickets =
          await FirestoreService().getTicketsByUserId(userId);
      setState(() {
        tickets = fetchedTickets;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đặt vé'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                Ticket ticket = tickets[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Vé xem phim: ${ticket.movieId}'),
                    subtitle:
                        Text('Ghế: ${ticket.seatNumber}\nNgày: ${ticket.stid}'),
                  ),
                );
              },
            ),
    );
  }
}
