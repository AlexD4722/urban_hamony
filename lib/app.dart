import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:urban_hamony/widgets/layout.dart';
import 'package:urban_hamony/widgets/login_page.dart';
import 'package:urban_hamony/widgets/screens/chooseRole.dart';
import 'package:urban_hamony/widgets/screens/homeScreen.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Layout(),
      routes: {
        '/home': (context) => const Layout(),
      },
    );
  }
}