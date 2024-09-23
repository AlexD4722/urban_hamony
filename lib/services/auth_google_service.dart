
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_hamony/services/database_service.dart';


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      //clear local
    }catch(e) {
      print(e);
    }
  }
  signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    final currentUser = await FirebaseAuth.instance.signInWithCredential(credential);await _databaseService.addUser(currentUser.user!.email.toString(), currentUser.user!.uid.toString());
    return currentUser;
  }

}