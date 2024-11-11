// database/showtime_data.dart
import '../models/showtime.dart';

/// giá trị datetime Năm - Tháng , Ngày , Giờ , Phút
List<Showtime> sampleShowtimes = [
  Showtime(
    stid: '1',
    movieId: '1',
    theaterId: '1',
    startTime: DateTime(2024, 6, 21, 9, 0),
    endTime: DateTime(2024, 6, 21, 10, 30),
    date: DateTime(2024, 6, 21),
  ),
  Showtime(
    stid: '2',
    movieId: '2',
    theaterId: '2',
    startTime: DateTime(2024, 6, 21, 20, 0),
    endTime: DateTime(2024, 6, 21, 22, 0),
    date: DateTime(2024, 6, 21),
  ),
  Showtime(
    stid: '3',
    movieId: '3',
    theaterId: '3',
    startTime: DateTime(2024, 6, 22, 18, 0),
    endTime: DateTime(2024, 6, 22, 20, 0),
    date: DateTime(2024, 6, 22),
  ),
];
