import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviebookingapp/main.dart';
import 'package:moviebookingapp/database/firestore_service.dart';
import 'package:moviebookingapp/models/user.dart'
    as model; // Import the User model with an alias

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _selectedColor = Colors.black;
  static const Color _unSelectedColor = Colors.grey;

  Color _emailTFColor = _unSelectedColor;
  Color _passwordColor = _unSelectedColor;
  Color _confirmPasswordColor = _unSelectedColor;
  Color _nameTFColor = _unSelectedColor;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Create a new user object
      final newUser = model.User(
        uid: userCredential.user!.uid,
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        role: 'user',
      );

      // Save login state to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userCredential.user!.uid);

      // Store additional user info in Firestore
      await _firestoreService
          .addUser(newUser); // This line stores user in Firestore

      // Navigate to the main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (ctx) => MainScreen(
                userId: userCredential.user!.uid, toggleThemeMode: () {})),
      );
    } on auth.FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = 'Error: Something went wrong.';

      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
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
                _buildTextField(
                  controller: _nameController,
                  label: "Name",
                  color: _nameTFColor,
                  onChanged: (color) {
                    setState(() {
                      _nameTFColor = color;
                    });
                  },
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _emailController,
                  label: "Email or Phone number",
                  color: _emailTFColor,
                  onChanged: (color) {
                    setState(() {
                      _emailTFColor = color;
                    });
                  },
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  color: _passwordColor,
                  obscureText: true,
                  onChanged: (color) {
                    setState(() {
                      _passwordColor = color;
                    });
                  },
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  color: _confirmPasswordColor,
                  obscureText: true,
                  onChanged: (color) {
                    setState(() {
                      _confirmPasswordColor = color;
                    });
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 164, 165, 165),
                          ),
                          onPressed: _register,
                          child: const Text('Register'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color color,
    bool obscureText = false,
    required Function(Color) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: color),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 16, top: 8),
        ),
        onChanged: (_) => onChanged(_selectedColor),
        onTap: () => onChanged(_selectedColor),
        onEditingComplete: () => onChanged(_unSelectedColor),
      ),
    );
  }
}
