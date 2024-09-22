import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:urban_hamony/widgets/screens/adm_blog_screen.dart';
import 'package:urban_hamony/widgets/screens/adm_product_screen.dart';
import 'package:urban_hamony/widgets/screens/galleryScreen.dart';
import 'package:urban_hamony/widgets/screens/homeScreen.dart';
import 'package:urban_hamony/widgets/screens/projectScreen.dart';
import '../providers/root.dart';
import 'dart:math' as math;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final HashMap<String, Widget> screens =
  HashMap<String, Widget>.fromIterables([
    'Home',
    'Project',
    'Gallery',
    'Profile'
  ], [
    const HomeScreen(),
    const ProductListPage(),
    const BlogListPage(),
    const ProjectScreen()
  ]);
  final List<String> screenNames = ['Home', 'Project', 'Gallery', 'Profile'];
  final _navBarItems = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.orange,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.work),
      title: const Text("Products"),
      selectedColor: Colors.redAccent,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.photo_library),
      title: const Text("Blogs"),
      selectedColor: Colors.lightBlueAccent,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Profile"),
      selectedColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;
    var selectedIndex =
    context.select((RootProvider provider) => provider.pageIndex);
    var setIndex = context.read<RootProvider>().setPageIndex;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
            child: screens[selectedIndex],
          )
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: context
              .select((RootProvider provider) => provider.getPageIndex()),
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setIndex(screenNames[index]);
          },
          items: _navBarItems),
    );
  }
}