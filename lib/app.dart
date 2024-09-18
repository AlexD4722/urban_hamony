import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:urban_hamony/widgets/login_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}