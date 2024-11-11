// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:moviebookingapp/models/ticket.dart';
// Future<void> addSampleTickets() async {
//   List<Ticket> tickets = [
//     Ticket(
//       tkid: '1',
//       movieId: '1',
//       userId: 'user1',
//       stid: '2SQW6vVRwMbAv0kixCptYyeAIP12',
//       seatNumber: 'A1',
//     ),
//     Ticket(
//       tkid: '2',
//       movieId: '2',
//       userId: '2',
//       stid: 'stid2',
//       seatNumber: 'B2',
//     ),
//     Ticket(
//       tkid: '3',
//       movieId: '3',
//       userId: 'user3',
//       stid: '3',
//       seatNumber: 'C3',
//     ),
//   ];

//   CollectionReference ticketsCollection = FirebaseFirestore.instance.collection('tickets');

//   for (var ticket in tickets) {
//     await ticketsCollection.add(ticket.toMap());
//   }
// }
