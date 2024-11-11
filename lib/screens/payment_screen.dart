
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_braintree/flutter_braintree.dart';
// import '../models/ticket.dart';
// import '../models/movie.dart';
// import '../models/showtime.dart';
// import '../screens/success_screen.dart';
// import '../database/firestore_service.dart';

// class PaymentScreen extends StatelessWidget {
//   final List<Ticket> tickets;
//   final double totalAmount;
//   final FirestoreService firestoreService = FirestoreService();

//   PaymentScreen({required this.tickets, required this.totalAmount});

//   Future<void> _startPayment(BuildContext context) async {
//     final request = BraintreeDropInRequest(
//       tokenizationKey: 'sandbox_38qh6brd_kf6td89vd4p77y3w',
//       collectDeviceData: true,
//       paypalRequest: BraintreePayPalRequest(
        
//         amount: totalAmount.toString(),
//         displayName: 'Your Company',
//       ),
//       cardEnabled: true,
//       googlePaymentRequest: BraintreeGooglePaymentRequest(
//         totalPrice:totalAmount.toString(), currencyCode: 'USD'),
//       paypalEnabled: true,
//       vaultManagerEnabled:true,
//     );

//     final result = await BraintreeDropIn.start(request);
//     if (result != null) {
//       // Handle successful payment
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (ctx) => SuccessScreen(),
//         ),
//       );
//     } else {
//       // Handle payment cancellation
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment was cancelled')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Tickets',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             FutureBuilder(
//               future: fetchTicketDetails(),
//               builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else {
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else {
//                     return Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: tickets.length,
//                         itemBuilder: (context, index) {
//                           Ticket ticket = tickets[index];
//                           Movie movie = snapshot.data![index]['movie'];
//                           Showtime showtime = snapshot.data![index]['showtime'];

//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     movie.title,
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Text(
//                                     'Seat Number: ${ticket.seatNumber}',
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                   SizedBox(height: 5),
//                                   RichText(
//                                     text: TextSpan(
//                                       text: 'Showtime: ',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.black,
//                                       ),
//                                       children: <TextSpan>[
//                                         TextSpan(
//                                           text: '${showtime.startTime} - ${showtime.endTime}',
//                                           style: TextStyle(fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 }
//               },
//             ),
//             SizedBox(height: 20),
//             Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () => _startPayment(context),
//                 child: Text('Proceed to Payment'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<List<Map<String, dynamic>>> fetchTicketDetails() async {
//     List<Map<String, dynamic>> ticketDetails = [];

//     for (Ticket ticket in tickets) {
//       Movie movie = await firestoreService.getMovieById(ticket.movieId);
//       Showtime showtime = await firestoreService.getShowtimeById(ticket.stid);

//       ticketDetails.add({
//         'movie': movie,
//         'showtime': showtime,
//       });
//     }

//     return ticketDetails;
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_braintree/flutter_braintree.dart';
import '../models/ticket.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../screens/success_screen.dart';
import '../database/firestore_service.dart';

class PaymentScreen extends StatelessWidget {
  final List<Ticket> tickets;
  final double totalAmount;
  final FirestoreService firestoreService = FirestoreService();

  PaymentScreen({required this.tickets, required this.totalAmount});

  Future<void> _startPayment(BuildContext context) async {
    final request = BraintreeDropInRequest(
      email:'kokaa4624@gmail.com',
      tokenizationKey:'sandbox_38qh6brd_kf6td89vd4p77y3w',
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: totalAmount.toString(),
        displayName: 'Your Company',
       payPalPaymentIntent: PayPalPaymentIntent.authorize,
        payPalPaymentUserAction: PayPalPaymentUserAction.commit,
      ),
      cardEnabled: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: totalAmount.toString(),
        currencyCode: 'USD',
        billingAddressRequired: false,
        googleMerchantID: '5398210050',
      ),
      paypalEnabled: false,
      vaultManagerEnabled: false,

    );

    final result = await BraintreeDropIn.start(request);
    if (result != null) {
      // Handle successful payment
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => SuccessScreen(),
        ),
      );
    } else {
      // Handle payment cancellation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment was cancelled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tickets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: fetchTicketDetails(),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          Ticket ticket = tickets[index];
                          Movie movie = snapshot.data![index]['movie'];
                          Showtime showtime = snapshot.data![index]['showtime'];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Seat Number: ${ticket.seatNumber}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Showtime: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${showtime.startTime} - ${showtime.endTime}',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 20),
            Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _startPayment(context),
                child: Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchTicketDetails() async {
    List<Map<String, dynamic>> ticketDetails = [];

    for (Ticket ticket in tickets) {
      Movie movie = await firestoreService.getMovieById(ticket.movieId);
      Showtime showtime = await firestoreService.getShowtimeById(ticket.stid);

      ticketDetails.add({
        'movie': movie,
        'showtime': showtime,
      });
    }

    return ticketDetails;
  }
}
