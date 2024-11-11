// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:moviebookingapp/main.dart';
// import 'package:moviebookingapp/screens/admin_dashboard.dart';
// import 'package:moviebookingapp/database/firestore_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   static const Color _selectedColor = Colors.black;
//   static const Color _unSelectedColor = Colors.grey;

//   Color _emailTFColor = _unSelectedColor;
//   Color _passwordColor = _unSelectedColor;

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirestoreService _firestoreService = FirestoreService();

//   bool _isLoading = false;
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final UserCredential userCredential =
//           await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text,
//       );

//       // Save login state to shared preferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('isLoggedIn', true);
//       await prefs.setString('userId', userCredential.user!.uid);

//       // Check user role after successful login
//       await _checkUserRole(userCredential.user!.uid);
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       String errorMessage = 'Error: Something went wrong.';

//       if (e.code == 'user-not-found') {
//         errorMessage = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         errorMessage = 'Wrong password provided for that user.';
//       } else {
//         errorMessage = 'Error: ${e.message}';
//       }

//       _showErrorDialog(errorMessage);
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       _showErrorDialog('Error: $e');
//     }
//   }

//   Future<void> _checkUserRole(String uid) async {
//     try {
//       final String? role = await _firestoreService.checkUserRole(uid);

//       if (role != null) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (ctx) => role == 'admin' ? AdminDashboard() : MainScreen(userId: uid),
//           ),
//         );
//       } else {
//         _showErrorDialog('User data not found.');
//       }
//     } catch (e) {
//       _showErrorDialog('Error fetching user role: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(16, 80, 16, 36),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'lib/images/logo.png',
//                   width: 260,
//                   height: 260,
//                 ),
//                 const SizedBox(height: 64),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: _emailTFColor),
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   child: TextFormField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: "Email or Phonenumber",
//                       labelStyle: TextStyle(color: _emailTFColor),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.only(left: 16, top: 8),
//                     ),
//                     onChanged: (_) {
//                       setState(() {
//                         _emailTFColor = _selectedColor;
//                       });
//                     },
//                     onTap: () {
//                       setState(() {
//                         _emailTFColor = _selectedColor;
//                       });
//                     },
//                     onEditingComplete: () {
//                       setState(() {
//                         _emailTFColor = _unSelectedColor;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: _passwordColor),
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   child: TextFormField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       labelStyle: TextStyle(color: _passwordColor),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.only(left: 16, top: 8),
//                     ),
//                     onChanged: (_) {
//                       setState(() {
//                         _passwordColor = _selectedColor;
//                       });
//                     },
//                     onTap: () {
//                       setState(() {
//                         _passwordColor = _selectedColor;
//                       });
//                     },
//                     onEditingComplete: () {
//                       setState(() {
//                         _passwordColor = _unSelectedColor;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 TextButton(
//                   onPressed: () {
//                     // Handle forgot password logic
//                   },
//                   child: const Text('Forget Password'),
//                 ),
//                 const SizedBox(height: 24),
//                 _isLoading
//                     ? CircularProgressIndicator()
//                     : SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color.fromARGB(255, 164, 165, 165),
//                           ),
//                           onPressed: _login,
//                           child: const Text('Login'),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviebookingapp/main.dart';
import 'package:moviebookingapp/screens/admin_dashboard.dart';
import 'package:moviebookingapp/database/firestore_service.dart';
import 'package:moviebookingapp/screens/register_screen.dart'; // Import RegisterScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color _selectedColor = Colors.black;
  static const Color _unSelectedColor = Colors.grey;

  Color _emailTFColor = _unSelectedColor;
  Color _passwordColor = _unSelectedColor;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Save login state to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userCredential.user!.uid);

      // Check user role after successful login
      await _checkUserRole(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = 'Error: Something went wrong.';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      _showErrorDialog(errorMessage);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error: $e');
    }
  }

  Future<void> _checkUserRole(String uid) async {
    try {
      final String? role = await _firestoreService.checkUserRole(uid);

      if (role != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (ctx) => role == 'admin'
                  ? AdminDashboard()
                  : MainScreen(userId: uid, toggleThemeMode: () {})),
        );
      } else {
        _showErrorDialog('User data not found.');
      }
    } catch (e) {
      _showErrorDialog('Error fetching user role: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 36),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/logo.png',
                  width: 260,
                  height: 260,
                ),
                const SizedBox(height: 64),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: _emailTFColor),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email or Phonenumber",
                      labelStyle: TextStyle(color: _emailTFColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 16, top: 8),
                    ),
                    onChanged: (_) {
                      setState(() {
                        _emailTFColor = _selectedColor;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _emailTFColor = _selectedColor;
                      });
                    },
                    onEditingComplete: () {
                      setState(() {
                        _emailTFColor = _unSelectedColor;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: _passwordColor),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: _passwordColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 16, top: 8),
                    ),
                    onChanged: (_) {
                      setState(() {
                        _passwordColor = _selectedColor;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _passwordColor = _selectedColor;
                      });
                    },
                    onEditingComplete: () {
                      setState(() {
                        _passwordColor = _unSelectedColor;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 164, 165, 165),
                          ),
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
