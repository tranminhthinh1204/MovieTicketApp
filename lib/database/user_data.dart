// lib/data/user_data.dart

class UserData {
  static final List<Map<String, String>> sampleUsers = [
    {'name':'user1','email': 'user1@example.com', 'password': 'password1', 'role': 'user'},
    {'name':'user2','email': 'user2@example.com', 'password': 'password2', 'role': 'user'},
    {'name':'admin','email': 'admin@example.com', 'password': 'adminpassword', 'role': 'admin'},
  ];

  static List<Map<String, String>> getSampleUsers() {
    return sampleUsers;
  }
}
