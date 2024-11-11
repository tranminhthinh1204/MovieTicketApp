import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviebookingapp/main.dart'; // Thay đổi đường dẫn tới MainScreen của bạn

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Đặt vé thành công',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getString('userId');

                if (userId != null) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            MainScreen(userId: userId, toggleThemeMode: () {})),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: Text('Quay về màn hình chính'),
            ),
          ],
        ),
      ),
    );
  }
}
