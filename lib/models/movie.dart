// import 'package:cloud_firestore/cloud_firestore.dart';

// class Movie {
//   final String id;
//   final String price;
//   final String title;
//   final String genre;
//   final String description;
//   final String imageUrl;
//   final String Director;

//   Movie({
//     required this.id,
//     required this.title,
//     required this.genre,
//     required this.description,
//     required this.price,
//     required this.imageUrl,
//     required this.Director,
//   });

//   factory Movie.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map;
//     return Movie(
//       id: doc.id,
//       title: data['title'] ?? '',
//       genre: data['genre'] ?? '',
//       description: data['description'] ?? '',
//       price: data['price'] ?? '',
//       imageUrl: data['imageUrl'] ?? '',
//       Director: data['Director'] ?? '',
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  // final String price;
  final String title;
  final List<String> genres; // Thay đổi từ String sang List<String>
  final String description;
  final String imageUrl;
  final String Director;
  final String videoUrl;

  Movie({
    required this.id,
    required this.title,
    required this.genres, // Thay đổi từ String sang List<String>
    required this.description,
    // required this.price,
    required this.imageUrl,
    required this.Director,
    required this.videoUrl,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    List<String> genresList = (data['genres'] as List<dynamic>).map((genre) => genre.toString()).toList();
    return Movie(
      id: doc.id,
      title: data['title'] ?? '',
      genres: genresList,
      description: data['description'] ?? '',
      // price: data['price'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      Director: data['Director'] ?? '',
      videoUrl:data['videoUrl'] ??'',
    );
  }
}
