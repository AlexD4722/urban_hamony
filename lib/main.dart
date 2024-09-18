import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_hamony/providers/root.dart';

import 'app.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => RootProvider()),
  ], child: const Application()));
}
