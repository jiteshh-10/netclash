import 'package:flutter/material.dart';
import 'package:netclash/services/auth_service.dart';
import 'package:netclash/screens/home_screen.dart';
import 'package:netclash/utils/validators.dart';
import 'package:netclash/utils/constants.dart';
import 'package:netclash/widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final user = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _displayNameController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Error signing up. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.padding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(labelText: 'Display Name'),
                validator: displayNameValidator,
              ),
              SizedBox(height: AppSizes.padding),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: emailValidator,
              ),
              SizedBox(height: AppSizes.padding),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: passwordValidator,
              ),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: AppColors.errorColor),
                  ),
                ),
              SizedBox(height: AppSizes.padding),
              CustomButton(
                text: 'Sign Up',
                onPressed: _signUp,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}