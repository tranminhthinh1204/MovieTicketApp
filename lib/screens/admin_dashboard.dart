import 'package:flutter/material.dart';
import 'package:moviebookingapp/app_colors.dart';

import 'manage_movies.dart';
import 'manage_showtimes.dart';
import 'manage_tickets.dart';
import 'manage_users.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: AppColors.admin_color,
          title: Text('Admin Dashboard', style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white
          ),),
          bottom: TabBar(tabs: [
            Tab(text: 'Ql Phim',),
            Tab(text: 'Ql Lịch chiếu',),
            Tab(text: 'Ql Người dùng',),
            Tab(text: 'Ql Vé',),
          ], isScrollable: true, indicatorColor: Colors.greenAccent, labelColor: Colors.white,  unselectedLabelColor: Colors.black54),
        ),
        body: const TabBarView(
          children: <Widget>[
            ManageMoviesPage(),
            ManageShowtimesPage(),
            ManageUsersPage(),
            ManageTicketsPage(),
          ],
        ),
      ),
    );
  }
}