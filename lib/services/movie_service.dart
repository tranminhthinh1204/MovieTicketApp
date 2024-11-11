// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/movie.dart';

// class MovieService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Movie>> fetchMovies() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection('movies').get();
//       return querySnapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList();
//     } catch (e) {
//       throw e;
//     }
//   }
// }
