import 'package:flutter/material.dart';
import 'package:moviebookingapp/app_colors.dart';
import 'package:moviebookingapp/models/ticket.dart';
import 'package:uuid/uuid.dart';

import '../database/firestore_service.dart';

class ManageTicketsPage extends StatefulWidget {
  const ManageTicketsPage({super.key});

  @override
  State<ManageTicketsPage> createState() => _ManageTicketsPageState();
}

class _ManageTicketsPageState extends State<ManageTicketsPage> {
  List<Ticket> data = [];
  TextEditingController tkidController = TextEditingController();
  TextEditingController movieIdController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController stidController = TextEditingController();
  TextEditingController seatNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    data.clear();
    FirestoreService firestoreService = FirestoreService();
    List<Ticket> tickets = await firestoreService.getAllTickets();

    setState(() {
      data.addAll(tickets);
    });
    print('data size: ${tickets.length}');
  }

  void _addTicket({Ticket? ticket}) async {
    tkidController.text = '';
    movieIdController.text = '';
    userIdController.text = '';
    stidController.text = '';
    seatNumberController.text = '';

    bool isEdit = false;
    if (ticket != null) {
      isEdit = true;
      tkidController.text = ticket.stid;
      movieIdController.text = ticket.movieId;
      userIdController.text = ticket.userId;
      stidController.text = ticket.stid;
      seatNumberController.text = ticket.seatNumber;
    }

    showBottomSheet(
        context: context,
        builder: (c) {
          return Container(
            color: AppColors.admin_color,
            padding: EdgeInsets.symmetric(horizontal: 20),
            // height: MediaQuery.of(context).size.height/2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      isEdit ? 'Sửa dữ liệu' : 'Thêm dữ liệu',
                      style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro'),
                    ),
                  ),
                  (tkidController.text == '') ? SizedBox.shrink() : Text('tkid: ${tkidController.text}'),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: movieIdController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'movieId',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: userIdController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'userId',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: stidController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'stid',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: seatNumberController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'seatNumber',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          if (
                              seatNumberController.text == '' ||
                              stidController.text == '' ||
                              userIdController.text == '' ||
                              movieIdController.text == '') {
                            return;
                          }
                          Ticket newTicket = Ticket(
                            stid: stidController.text,
                            movieId: movieIdController.text,
                            userId: userIdController.text,
                            tkid: isEdit ? tkidController.text : Uuid().v4(),
                            seatNumber: seatNumberController.text,);

                          isEdit
                              ? _readyEditTicket(newTicket)
                              : _readyAddTicket(newTicket);
                        },
                        child: Text('Đồng ý')),
                  ),
                ],
              ),
            ),
          );
        });
    // await FirestoreService().addTickets();
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
                  Ticket ticket = data[index];
                  return _itemTicketWidget(ticket);
                }),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  _addTicket();
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

  Widget _itemTicketWidget(Ticket ticket) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
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
                    Text('tkid: ${ticket.tkid}', style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')),
                    Text('user: ${ticket.userId}', style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')),
                    Text('movieId: ${ticket.movieId}', style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')),
                    Text('stid: ${ticket.stid}', style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')),
                    Text('seatNumber: ${ticket.seatNumber}', style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')),
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
                            _addTicket(ticket: ticket);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            _readyRemoveTicket(ticket);
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

  void _readyAddTicket(Ticket ticket) async {
    await FirestoreService().addTicket(ticket);
    Navigator.pop(context);
    fetchData();
  }

  void _readyEditTicket(Ticket newTicket) async {
    await FirestoreService().updateTicket(newTicket);
    Navigator.pop(context);
    fetchData();
  }

  void _readyRemoveTicket(Ticket newTicket) async {
    await FirestoreService().deleteTicket(newTicket.tkid);
    fetchData();
  }
}
