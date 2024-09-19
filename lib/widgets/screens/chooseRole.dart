import 'package:flutter/material.dart';
import 'package:urban_hamony/widgets/screens/userInfoPage.dart';

import '../components/bezierContainer.dart';

class ChooseRole extends StatefulWidget {
  ChooseRole({Key? key}) : super(key: key);

  @override
  _ChooseRoleState createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  String? selectedRole;
  void _selectRole(String role) {
    setState(() {
      selectedRole = role;
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  _buildStepIndicator(),
                  const SizedBox(height: 40),
                  const Text(
                    'Choose Your Role',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Select the role that best describes you',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildRoleButton(
                        context,
                        'Designer',
                        'designer',
                        const Color(0xFF73C4F8),
                        Icons.brush,
                            () => _selectRole('designer'),
                      ),
                      const SizedBox(height: 20),
                      _buildRoleButton(
                        context,
                        'Customer',
                        'customer',
                        Colors.green,
                        Icons.person,
                            () => _selectRole('customer'),
                      ),
                    ],
                  ),
                ),
              ),
                ],
              ),
            ),
          ),
          if (selectedRole != null)
            Positioned(
              right: 20,
              bottom: 20,
              child: _buildNextButton(),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: const Text(
        'Step 1',
        style: TextStyle(
          color: Colors.black,
          fontSize: 23,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Colors.black,
          decorationThickness: 1.5,
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role, String value,
      Color color, IconData icon, VoidCallback onPressed) {
    final isSelected = selectedRole == value;
    return Material(
      elevation: isSelected ? 12 : 8,
      borderRadius: BorderRadius.circular(20),
      color: color,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: Colors.white, width: 3)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(width: 20),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInfoPage(role: selectedRole!),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE53935),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        elevation: 5,
      ),
      child: const Text(
        'Next',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
