import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:urban_hamony/widgets/screens/homeScreen.dart';
import 'package:urban_hamony/widgets/screens/productScreen.dart';
import 'package:urban_hamony/widgets/screens/profileScreen.dart';
import 'package:urban_hamony/widgets/screens/projectScreen.dart';
import '../providers/root.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final HashMap<String, Widget> screens = HashMap<String, Widget>.fromIterables([
    'Home',
    'Product',
    'Project',
    'Profile',
  ], [
    const HomeScreen(),
    const ProductScreen(),
    const ProjectScreen(),
    const ProfileScreen()
  ]);

  final List<String> screenNames = ['Home', 'Product', 'Project', 'Profile'];

  final _navBarItems = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.orange,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.shopping_bag),
      title: const Text("Product"),
      selectedColor: Colors.purple,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.build),
      title: const Text("Projects"),
      selectedColor: Colors.redAccent,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Profile"),
      selectedColor: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var selectedIndex = context.select((RootProvider provider) => provider.pageIndex);
    var setIndex = context.read<RootProvider>().setPageIndex;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: screens[screenNames[selectedIndex]]!,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: (index) {
          setIndex(index);
        },
        items: _navBarItems,
      ),
    );
  }
}