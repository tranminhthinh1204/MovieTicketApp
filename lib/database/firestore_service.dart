import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';
import '../models/ticket.dart';
import '../models/user.dart' as AppUser;
import '../models/showtime.dart';
import '../models/genre.dart';
import '../database/genre_data.dart';
import '../database/movie_data.dart';
import '../database/showtime_data.dart';
import '../database/user_data.dart';



class FirestoreService 
{
  final CollectionReference moviesCollection =
      FirebaseFirestore.instance.collection('movies');
  final CollectionReference genresCollection =
      FirebaseFirestore.instance.collection('genres');
        final CollectionReference showtimeCollection =
      FirebaseFirestore.instance.collection('showtime');
       final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('ticket');
        final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addMovies(Movie movie) async {
    await moviesCollection.doc(movie.id).set({
      'title': movie.title,
      'genre': movie.genres,
      'Director': movie.Director,
      'description': movie.description,
      'imageUrl': movie.imageUrl,
      'videoUrl': movie.videoUrl,
    });
    print('movies added to Firestore');
  }

  Future<void> updateMovie(Movie movie) async {
    try {
      await moviesCollection.doc(movie.id).update({
        'title': movie.title,
        'genre': movie.genres,
        'director': movie.Director,
        'description': movie.description,
        'imageUrl': movie.imageUrl,
        'videoUrl': movie.videoUrl,
      });
      print('Movie updated successfully');
    } catch (e) {
      print('Error updating movie: $e');
    }
  }

  Future<void> deleteMovie(String id) async {
    try {
      await moviesCollection.doc(id).delete();
      print('Movie deleted successfully');
    } catch (e) {
      print('Error deleting movie: $e');
    }
  }

  Future<void> addSampleMovies() async {
    for (Movie movie in sampleMovies) {
      await moviesCollection.doc(movie.id).set({
        'title': movie.title,
        'genre': movie.genres,
        'Director': movie.Director,
        'description': movie.description,
        'imageUrl': movie.imageUrl,
        'videoUrl':movie.videoUrl,
      });
    }
    print('Sample movies added to Firestore');
  }

  Future<void> addSampleGenres() async {
    for (Genre genre in sampleGenres) {
      await genresCollection.doc(genre.id).set({
        'id': genre.id,
        'name': genre.name,
      });
    }
    print('Sample genres added to Firestore');
  }

  Future<void> updateShowtimes(Showtime showtime) async {
    try {
      await showtimeCollection.doc(showtime.stid).update(showtime.toMap());
      print('Movie updated successfully');
    } catch (e) {
      print('Error updating movie: $e');
    }
  }

  Future<void> deleteShowtimes(String id) async {
    try {
      await showtimeCollection.doc(id).delete();
      print('Movie deleted successfully');
    } catch (e) {
      print('Error deleting movie: $e');
    }
  }

  Future<void> addShowtimes(Showtime showtime) async {
    await showtimeCollection.doc(showtime.stid).set(showtime.toMap());
    print('Sample showtimes added to Firestore');
  }

  Future<void> addSampleShowtimes() async {
    for (Showtime showtime in sampleShowtimes) {
      await showtimeCollection.doc(showtime.stid).set(showtime.toMap());
    }
    print('Sample showtimes added to Firestore');
  }

  Future<List<Movie>> getMovies() async {
    QuerySnapshot snapshot = await moviesCollection.get();
    return snapshot.docs.map((doc) {
      List<String> genresList = List<String>.from(doc['genre']);

      return Movie(
        id: doc.id,
        title: doc['title'],
        genres: genresList,
        Director: doc['Director'],
        description: doc['description'],
        imageUrl: doc['imageUrl'],
        videoUrl:doc['videoUrl'],
      );
    }).toList();
  }

  Future<Movie> getMovieById(String id) async {
    DocumentSnapshot doc = await moviesCollection.doc(id).get();
    List<String> genresList = List<String>.from(doc['genre']);

    return Movie(
      id: doc.id,
      title: doc['title'],
      genres: genresList,
      description: doc['description'],
      // price: doc['price'],
      imageUrl: doc['imageUrl'],
      Director: doc['Director'],
      videoUrl:doc['videoUrl'],
    );
  }

  Future<List<Genre>> getGenres() async {
    QuerySnapshot snapshot = await genresCollection.get();
    return snapshot.docs.map((doc) {
      return Genre(
        id: doc.id,
        name: doc['name'],
      );
    }).toList();
  }

// Future<void> createUserWithEmailAndPassword(String name,String email, String password, String role) async {
//     try {
//       // Tạo người dùng với email và mật khẩu
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Lấy UID của người dùng
//       String uid = userCredential.user!.uid;

//       // Thêm thông tin người dùng vào Firestore
//       await usersCollection.doc(uid).set({
//         'email': email,
//         'name': name,
//         'role': role,
//       });
//     } catch (e) {
//       print('Error creating user: $e');
//     }
//   }
Future<void> createUserWithEmailAndPassword(
    String name, String email, String password, String role) async {
  try {
    // Tạo người dùng với email và mật khẩu
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Lấy UID của người dùng
    String uid = userCredential.user!.uid;

    // Thêm thông tin người dùng vào Firestore
    await usersCollection.doc(uid).set({
      'email': email,
      'name': name,
      'role': role,
    });

    print('User added to Firestore');

  } catch (e) {
    print('Error creating user: $e');
  }
}

  Future<void> createSampleUsers() async {
    for (var user in UserData.getSampleUsers()) {
      await createUserWithEmailAndPassword(
          user['name']!, user['email']!, user['password']!, user['role']!);
    }
  }

  Future<void> addUsers(AppUser.User user, String password) async {
    await createUserWithEmailAndPassword(
        user.name, user.email, password, user.role);
  }

  Future<void> updateUser(AppUser.User newUser) async {
    try {
      await usersCollection.doc(newUser.uid).update({
        'email': newUser.email,
        'name': newUser.name,
        'role': newUser.role,
      });
      print('Movie updated successfully');
    } catch (e) {
      print('Error updating movie: $e');
    }
  }

  Future<void> deleteUser(id) async {
    try {
      await usersCollection.doc(id).delete();
      print('Movie deleted successfully');
    } catch (e) {
      print('Error deleting movie: $e');
    }
  }

     Future<String?> checkUserRole(String uid) async {
    try {
      final DocumentSnapshot snapshot =
          await usersCollection.doc(uid).get();

      if (snapshot.exists) {
        final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('role')) {
          return data['role'] as String?;
        } else {
          return null; // No role field or role is null
        }
      } else {
        return null; 
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  Future<List<Showtime>> getShowtimes() async {
    QuerySnapshot snapshot = await showtimeCollection.get();
    return snapshot.docs.map((doc) {
      return Showtime(
        stid: doc.id,
        movieId: doc['movieId'],
        theaterId: doc['theaterId'],
        startTime: DateTime.parse(doc['startTime']),
        endTime: DateTime.parse(doc['endTime']),
        date: DateTime.parse(doc['date']),
      );
    }).toList();
  }

  Future<Showtime> getShowtimeById(String id) async {
    DocumentSnapshot doc = await showtimeCollection.doc(id).get();
    return Showtime.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<List<Showtime>> getShowtimesByMovieId(String movieId) async {
    QuerySnapshot snapshot = await showtimeCollection.where('movieId', isEqualTo: movieId).get();
    return snapshot.docs.map((doc) {
      dynamic startTimeField = doc['startTime'];
      dynamic endTimeField = doc['endTime'];
      dynamic dateField = doc['date'];

      DateTime startTime = startTimeField is Timestamp ? startTimeField.toDate() : DateTime.parse(startTimeField);
      DateTime endTime = endTimeField is Timestamp ? endTimeField.toDate() : DateTime.parse(endTimeField);
      DateTime date = dateField is Timestamp ? dateField.toDate() : DateTime.parse(dateField);

      return Showtime(
        stid: doc.id,
        movieId: doc['movieId'],
        theaterId: doc['theaterId'],
        startTime: startTime,
        endTime: endTime,
        date: date,
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.get();
      List<Map<String, dynamic>> users = querySnapshot.docs.map((doc) {
        return {
          'uid': doc.id,
          'email': doc['email'],
          'name': doc['name'],
          'role': doc['role'],
        };
      }).toList();
      return users;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

     Future<AppUser.User> getUserById(String uid) async {
    DocumentSnapshot snapshot = await usersCollection.doc(uid).get();
    return AppUser.User.fromDocument(snapshot);
  }

  Future<List<Movie>> getMoviesByGenre(String genreId) async {
    try {
      QuerySnapshot snapshot = await moviesCollection.where('genre', arrayContains: genreId).get();
      return snapshot.docs.map((doc) {
        List<String> genresList = List<String>.from(doc['genre']);
        return Movie(
          id: doc.id,
          title: doc['title'],
          genres: genresList,
          Director: doc['Director'],
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          videoUrl:doc['videoUrl'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching movies by genre: $e');
      return []; // Return an empty list on error
    }
  }

  Future<List<Movie>> getMoviesByGenreName(String genreName) async {
  try {
    QuerySnapshot snapshot = await moviesCollection.where('genre', arrayContains: genreName).get();
    return snapshot.docs.map((doc) {
      List<String> genresList = List<String>.from(doc['genre']);
      
      return Movie(
        id: doc.id,
        title: doc['title'],
        genres: genresList,
        Director: doc['Director'],
        description: doc['description'],
        imageUrl: doc['imageUrl'],
        videoUrl:doc['videoUrl'],
      );
    }).toList();
  } catch (e) {
    print('Error fetching movies by genre name: $e');
    return []; // Return an empty list on error
  }
}
Future<List<Movie>> searchMoviesByName(String query) async {
  QuerySnapshot snapshot = await moviesCollection
      .where('title', isGreaterThanOrEqualTo: query)
      .where('title', isLessThanOrEqualTo: query + '\uf8ff')
      .get();
  return snapshot.docs.map((doc) {
    List<String> genresList = List<String>.from(doc['genre']);
    return Movie(
      id: doc.id,
      title: doc['title'],
      genres: genresList,
      Director: doc['Director'],
      description: doc['description'],
      imageUrl: doc['imageUrl'],
      videoUrl:doc['videoUrl'],
    );
  }).toList();
}
 Future<void> addTicket(Ticket ticket) {
    return ticketCollection.add(ticket.toMap());
  }
Future<List<Ticket>> getTicketsByUserId(String userId) async {
    QuerySnapshot querySnapshot = await ticketCollection.where('userId', isEqualTo: userId).get();

      return querySnapshot.docs.map((doc) => Ticket.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

 Future<List<Ticket>> getTicketsByShowtimeId(String showtimeId) async {
    QuerySnapshot snapshot = await ticketCollection.where('stid', isEqualTo: showtimeId).get();
    return snapshot.docs.map((doc) => Ticket.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<Ticket>> getAllTickets() async {
    try {
      QuerySnapshot querySnapshot = await ticketCollection.get();
      List<Ticket> tickets = querySnapshot.docs.map((doc) {
        return Ticket.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return tickets;
    } catch (e) {
      print('Error getting tickets: $e');
      return [];
    }
  }
  
  Future<void> deleteTicket(String tkid) async {
    try {
      await ticketCollection.doc(tkid).delete();
      print('Ticket deleted successfully');
    } catch (e) {
      print('Error deleting ticket: $e');
    }
  }

  // Hàm cập nhật thông tin một vé
  Future<void> updateTicket(Ticket ticket) async {
    try {
      await ticketCollection.doc(ticket.tkid).update(ticket.toMap());
      print('Ticket updated successfully');
    } catch (e) {
      print('Error updating ticket: $e');
    }
  }
   Future<void> addUser(AppUser.User user) {
    return usersCollection.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': user.name,
      'role': user.role,
    });
  }
}
