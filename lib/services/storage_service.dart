import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    Future<String?> uploadImage({
      File? file,
      String? email,
    }) async {
      Reference fileRef = _firebaseStorage
          .ref('users/pfps')
          .child('$email${p.extension(file!.path)}');
      UploadTask task = fileRef.putFile(file);
      return task.then((p){
        if(p.state == TaskState.success){
          return fileRef.getDownloadURL();
        }
      });
    }
}