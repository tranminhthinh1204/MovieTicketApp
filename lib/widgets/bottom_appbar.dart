import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          Color.fromARGB(255, 244, 244, 245), // Thay đổi màu nền ở đây
      selectedItemColor: const Color.fromARGB(
          255, 86, 86, 86), // Màu cho icon và label được chọn
      unselectedItemColor: Colors.grey, // Màu cho icon và label không được chọn
      selectedLabelStyle: TextStyle(
          color:
              const Color.fromARGB(255, 68, 68, 68)), // Màu cho label được chọn
      unselectedLabelStyle:
          TextStyle(color: Colors.grey), // Màu cho label không được chọn
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
