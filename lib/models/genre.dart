// genre.dart

import 'package:flutter/foundation.dart';

class Genre {
  final String id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Genre(
      id: documentId,
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
    };
  }
}
