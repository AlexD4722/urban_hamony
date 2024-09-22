import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'dart:io';

import '../../services/storage_service.dart';
import '../components/bezierContainer.dart';
import '../layout.dart';

class UserInfoPage extends StatefulWidget {
  final String role;
  final String email;
  UserInfoPage({Key? key, required this.role, required this.email}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  StorageService _storageService = StorageService();
  DatabaseService _databaseService = DatabaseService();
  File? _image;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _selectedGender;
  bool _showFinishButton = false;
  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_checkFields);
    _lastNameController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_checkFields);
    _lastNameController.removeListener(_checkFields);
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _checkFields() {
    setState(() {
      _showFinishButton = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _selectedGender != null && _image != null;
    });
  }
  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -height * .15,
            right: -MediaQuery.of(context).size.width * .4,
            child: const BezierContainer(),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        _buildStepIndicator(),
                        const SizedBox(height: 40),
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAvatarUpload(),
                        const SizedBox(height: 20),
                        _buildNameFields(),
                        const SizedBox(height: 20),
                        _buildGenderSelection(),
                      ],
                    ),
                  ),
                ),
                _buildNavigationButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNameFields() {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: _buildInputDecoration('First Name', 'Enter your first name', Icons.person),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _lastNameController,
          decoration: _buildInputDecoration('Last Name', 'Enter your last name', Icons.badge),
        ),
      ],
    );
  }
  Widget _buildNavigationButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              'Back',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          if (_showFinishButton)
            ElevatedButton(
              onPressed: () async {
                String? pfpUrl = await _storageService.uploadImage(
                  file: _image,
                  email: widget.email
                );
                if(pfpUrl != null) {
                  bool createStatus = await _databaseService.createProfile(
                      widget.email,
                      pfpUrl,
                      _firstNameController.text,
                      _lastNameController.text,
                      _selectedGender.toString(),
                      widget.role
                  );
                  if(createStatus){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Layout()),
                          (Route<dynamic> route) => false,
                    );
                  }
                }

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Finish',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: const Text(
        'Step 2',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black,
          decorationThickness: 1.5,
        ),
      ),
    );
  }

  Widget _buildAvatarUpload() {
    return Center(
      child: GestureDetector(
        onTap: _getImage,
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: _image == null
              ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600])
              : null,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xffe38b0e)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xffe38b0e), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      labelStyle: TextStyle(color: Colors.grey.shade700),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
       Flexible(child:  _buildGenderButton('Male', Icons.male)),
        const SizedBox(width: 10),
        Flexible(child: _buildGenderButton('Female', Icons.female))
      ],
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _checkFields();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffe38b0e) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? const Color(0xffe38b0e) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0xffe38b0e).withOpacity(0.5) : Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xffe38b0e),
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
