import 'package:flutter/material.dart';
import 'package:urban_hamony/services/auth_google_service.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'package:urban_hamony/widgets/screens/chooseRole.dart';

import 'components/bezierContainer.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  String _errorMessage = '';
  DatabaseService _databaseService = DatabaseService();
  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your $title';
                }
                if (title == "Email" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                if (title == "Password" && value.length <= 5) {
                  return 'Password must be greater than 5 characters';
                }
                if (title == "Confirm Password" && value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              })
        ],
      ),
    );
  }
  Widget _submitButton() {
    return InkWell(
      onTap: _isFormValid
          ? () async {
        if (_passwordController.text == _confirmPasswordController.text) {
          final signUpStatus = await _databaseService.addUser(_emailController.text, _passwordController.text);
          if (signUpStatus) {
            final currentUser = await _databaseService.login(_emailController.text, _passwordController.text);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChooseRole(email: currentUser!.email.toString())),
            );
          } else {
            setState(() {
              _errorMessage = 'Sign Up Failed';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Passwords do not match';
          });
        }
      }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: _isFormValid
                    ? [Color(0xfffbb448), Color(0xfff7892b)]
                    : [Colors.grey, Colors.grey])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Container(
      width: 80,
      child: Image.asset('assets/images/urban.png'),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", _emailController),
        _entryField("Password", _passwordController, isPassword: true),
        _entryField("Confirm Password",_confirmPasswordController, isPassword: true),
      ],
    );
  }
  Widget _errorMessageWidget() {
    return _errorMessage.isNotEmpty
        ? Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        _errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 14),
      ),
    )
        : Container();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  onChanged: _validateForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      _errorMessageWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: 20),
                      _loginAccountLabel(),
                    ],
                  ),
                )
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}