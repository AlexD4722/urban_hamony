import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:urban_hamony/providers/cartProvider.dart';
import 'package:urban_hamony/providers/roomTypeProvider.dart';
import 'package:urban_hamony/providers/root.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app.dart';
import 'consts.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await _setupStripe();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => RootProvider()),
    ChangeNotifierProvider(create: (context) => RoomTypeProvider()),
    ChangeNotifierProvider(create: (context) =>  CartProvider())
  ], child: Application()));
}
Future<void> _setupStripe() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}
