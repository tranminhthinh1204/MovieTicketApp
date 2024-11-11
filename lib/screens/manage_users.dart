import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../database/firestore_service.dart';
import '../models/user.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  List<User> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    data.clear();
    // List<User> users = await FirestoreService().getAllUsers();
    List<Map<String, dynamic>> map = await FirestoreService().getAllUsers();
    List<User> users = map.map((userMap) => User.fromMap(userMap)).toList();
    setState(() {
      // Update state with the fetched data
      data.addAll(users);
    });
    print('data size: ${users.length}');
  }

  void _addUser({User? user}) async {
    TextEditingController uidController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController roleController = TextEditingController();
    TextEditingController passController = TextEditingController();

    emailController.text = 'djaa@gmail.com';
    nameController.text = 'djaa@gmail.com';
    roleController.text = 'user';
    passController.text = 'user12345';

    bool isEdit = false;
    if (user != null) {
      isEdit = true;

      uidController.text = user.uid;
      emailController.text = user.email;
      nameController.text = user.name;
      roleController.text = user.role;
    }

    showBottomSheet(
        context: context,
        builder: (c) {
          return Container(
            // color: AppColors.admin_color,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    isEdit ? 'Sửa dữ liệu': 'Thêm dữ liệu',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                (uidController.text == '') ? SizedBox.shrink() : Text('uid: ${uidController.text}'),
                TextField(
                  textAlign: TextAlign.start,
                  controller: emailController,
                  decoration: const InputDecoration(
                    // border: B,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    alignLabelWithHint: true,
                    label: Text(
                      'email',
                    ),
                  ),
                ),
                TextField(
                  textAlign: TextAlign.start,
                  controller: nameController,
                  decoration: const InputDecoration(
                    // border: B,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    alignLabelWithHint: true,
                    label: Text(
                      'name',
                    ),
                  ),
                ),
                TextField(
                  textAlign: TextAlign.start,
                  controller: roleController,
                  decoration: const InputDecoration(
                    // border: B,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    alignLabelWithHint: true,
                    label: Text(
                      'role',
                    ),
                  ),
                ),
                isEdit ? SizedBox.shrink() :
                TextField(
                  textAlign: TextAlign.start,
                  controller: passController,
                  decoration: const InputDecoration(
                    // border: B,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    alignLabelWithHint: true,
                    label: Text(
                      'pass',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        if (
                            emailController.text == '' ||
                            nameController.text == '' ||
                            (passController.text == '' && !isEdit) ||
                            roleController.text == '') {
                          return;
                        }
                        User newUser = User(
                            uid: uidController.text,
                            email: emailController.text,
                            name: nameController.text,
                            role: roleController.text);

                        isEdit
                            ? _readyEditUser(newUser)
                            : _readyAddUser(newUser, passController.text);
                      },
                      child: Text('Đồng ý')),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: (data.length == 0)
                ? Center(
              child: Text('Không có dữ liệu'),
            )
                : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  User user = data[index];
                  return _itemUserWidget(user);
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  _addUser();
                },
                child: Text('Thêm dữ liệu')),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _itemUserWidget(User user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('uid: ${user.uid}'),
                    Text('email: ${user.email}', style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')),
                    Text('name: ${user.name}', style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro')),
                    Text('role: ${user.role}', style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16, fontFamily: 'BeVietnamPro'),
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            _addUser(user: user);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            _readyRemoveUser(user);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.orangeAccent,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _readyAddUser(User user, String pass) async {
    await FirestoreService().addUsers(user, pass);
    Navigator.pop(context);
    fetchData();
  }

  void _readyEditUser(User newUser) async {
    await FirestoreService().updateUser(newUser);
    Navigator.pop(context);
    fetchData();
  }

  void _readyRemoveUser(User newUser) async {
    await FirestoreService().deleteUser(newUser.uid);
    fetchData();
  }
}
