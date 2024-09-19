
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urban_hamony/services/database_service.dart';


class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  // signInWithEmailAndPassword(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email,
  //         password: password
  //     );
  //     print('signin success');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

  signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      //clear local
    }catch(e) {
      print(e);
    }
  }

  // signUpWithEmailAndPassword(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password
  //     );
  //     print('signup success');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('email-already-in-use');
  //     }
  //   } catch (e) {
  //     print('loi $e');
  //   }
  // }

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