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
  Future<List<String?>> uploadProductImages({
    required List<File> files,
    required String code,
  }) async {
    List<Future<String?>> uploadTasks = files.asMap().entries.map((entry) async {
      int index = entry.key;
      File file = entry.value;
      print('-----------$index');
      Reference fileRef = _firebaseStorage
          .ref('products/imgp')
          .child('$code-$index${p.extension(file.path)}');
      UploadTask task = fileRef.putFile(file);
      TaskSnapshot snapshot = await task;
      if (snapshot.state == TaskState.success) {
        return await fileRef.getDownloadURL();
      } else {
        return null;
      }
    }).toList();

    print(uploadTasks);
    return Future.wait(uploadTasks);
  }

  Future<String?> uploadBlogImage(File file, String code) async {
    try {
      Reference fileRef = FirebaseStorage.instance
          .ref('blogs/imgb')
          .child('$code${p.extension(file.path)}');
      UploadTask uploadTask = fileRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        return await fileRef.getDownloadURL();
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}