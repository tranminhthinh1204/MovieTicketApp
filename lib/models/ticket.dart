class Ticket {
  final String tkid;
  final String movieId;
  final String userId;
  final String stid;
  final String seatNumber;

  Ticket({
    required this.tkid,
    required this.movieId,
    required this.userId,
    required this.stid,
    required this.seatNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'tkid': tkid,
      'movieId': movieId,
      'userId': userId,
      'stid': stid,
      'seatNumber': seatNumber,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      tkid: map['tkid'],
      movieId: map['movieId'],
      userId: map['userId'],
      stid: map['stid'],
      seatNumber: map['seatNumber'],
    );
  }
}
