import 'package:flutter/material.dart';
import '../models/user.dart' as AppUser; // Import user model
import '../database/firestore_service.dart'; // Import Firestore service
import '../screens/ticket_history.dart';

class ProfileScreen extends StatefulWidget {
  final String userId; // Thêm thuộc tính userId để truyền vào ProfileScreen

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<AppUser.User?> _userFuture;
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  Future<AppUser.User?> _fetchUserData() async {
    if (widget.userId.isEmpty) {
      return null; // Trả về null nếu không có userId
    }

    try {
      AppUser.User user = await FirestoreService().getUserById(widget.userId);
      _nameController.text =
          user.name.toString(); // Cập nhật tên người dùng vào controller
      _emailController.text =
          user.email; // Cập nhật email người dùng vào controller
      return user;
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<AppUser.User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('Vui lòng đăng nhập'));
          } else {
            AppUser.User user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Thay thế ảnh đại diện bằng ảnh thực tế của người dùng
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    readOnly:
                        true, // Chỉ cho phép xem tên người dùng, không cho chỉnh sửa
                    decoration: InputDecoration(
                      labelText: 'Tên',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    readOnly:
                        true, // Chỉ cho phép xem email người dùng, không cho chỉnh sửa
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingHistoryScreen()),
                      );
                    },
                    child: Text('Xem lịch sử đặt vé'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Chuyển đến màn hình chỉnh sửa thông tin cá nhân
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfileScreen()),
                      );
                    },
                    child: Text('Thay đổi thông tin cá nhân'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin cá nhân'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lưu thông tin và quay lại màn hình trước đó
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
