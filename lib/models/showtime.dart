// models/showtime.dart
class Showtime {
  String stid;
  String movieId;
  String theaterId;
  DateTime startTime;
  DateTime endTime;
  DateTime date;

  Showtime({
    required this.stid,
    required this.movieId,
    required this.theaterId,
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  factory Showtime.fromMap(Map<String, dynamic> data) {
    return Showtime(
      stid: data['stid'],
      movieId: data['movieId'],
      theaterId: data['theaterId'],
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      date: DateTime.parse(data['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stid': stid,
      'movieId': movieId,
      'theaterId': theaterId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'date': date.toIso8601String(),
    };
  }
}
