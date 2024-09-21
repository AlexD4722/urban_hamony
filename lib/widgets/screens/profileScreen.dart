import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: const Color(0xFFF6F6F6),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 32),
            Expanded(child: _buildOptionsList()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF6F6F6),
      elevation: 0,
      toolbarHeight: 80,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.orange),
            onPressed: () {
              // Handle logout
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage('lib/assets/images/avatar.jpg'),
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'johndoe@example.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsList() {
    return ListView(
      children: [
        _buildListTile(Icons.settings, 'App Settings', () {
          // Navigate to App Settings screen
        }),
        _buildListTile(Icons.person, 'Profiles', () {
          // Navigate to Profiles screen
        }),
        _buildListTile(Icons.history, 'Order History', () {
          // Navigate to Order History screen
        }),
        _buildListTile(Icons.bookmark, 'Saved', () {
          // Navigate to Saved Items screen
        }),
        _buildExpansionTile(),
      ],
    );
  }

  ListTile _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }

  ExpansionTile _buildExpansionTile() {
    return ExpansionTile(
      leading: const Icon(Icons.help, color: Colors.orange, size: 30),
      title: const Text(
        'Support',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),

      ),
      shape: const Border(bottom: BorderSide(color: Colors.grey)),
      children: [
        _buildExpansionTileItem('Report Problem', () {
          // Navigate to Report Problem screen
        }),
        _buildExpansionTileItem('About', () {
          // Navigate to About screen
        }),
        _buildExpansionTileItem('Schedule', () {
          // Navigate to Schedule screen
        }),
      ],
    );
  }

  ListTile _buildExpansionTileItem(String title, VoidCallback onTap) {
    return ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onTap: onTap
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: const [
            Text(
              '© 2024',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            Text(
              'Authored by Ongbapcay Group',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}