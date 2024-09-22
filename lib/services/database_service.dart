import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_hamony/models/auth_model.dart';
import 'package:urban_hamony/models/product_model.dart';

import '../models/blog_model.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;
  CollectionReference? _productsCollection;
  CollectionReference? _blogsCollection;

  void _setupCollectionReferences() {
    _usersCollection = _firebaseFirestore
        .collection('users')
        .withConverter<UserModel>(
        fromFirestore: (snapshot, _) =>
            UserModel.fromJson(snapshot.data()!),
        toFirestore: (chat, _) => chat.toJson());
    _productsCollection = _firebaseFirestore
        .collection('products')
        .withConverter<ProductModel>(
        fromFirestore: (snapshot, _) =>
            ProductModel.fromJson(snapshot.data()!),
        toFirestore: (chat, _) => chat.toJson());
    _blogsCollection = _firebaseFirestore
        .collection('blogs')
        .withConverter<BlogModel>(
        fromFirestore: (snapshot, _) =>
            BlogModel.fromJson(snapshot.data()!),
        toFirestore: (chat, _) => chat.toJson());
  }

  Future<bool> getUser(String email) async {
    try{
      QuerySnapshot querySnapshot = await _usersCollection!
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel data = doc.data() as UserModel;
        UserModel user = UserModel.fromJson(data.toJson());
        if(user.email == email){
          return true;
        }
      }
      return false;
    } catch(e){
      return false;
    }
  }

  Future<bool> checkBlogExist(String code) async {
    try{
      QuerySnapshot querySnapshot = await _blogsCollection!
          .where('id', isEqualTo: code)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        BlogModel data = doc.data() as BlogModel;
        BlogModel blog = BlogModel.fromJson(data.toJson());
        if(blog.id == code){
          return true;
        }
      }
      return false;
    } catch(e){
      return false;
    }
  }

  Future<bool> checkProductExist(String code) async {
    try{
      QuerySnapshot querySnapshot = await _productsCollection!
          .where('code', isEqualTo: code)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        ProductModel data = doc.data() as ProductModel;
        ProductModel product = ProductModel.fromJson(data.toJson());
        if(product.code == code){
          return true;
        }
      }
      return false;
    } catch(e){
      return false;
    }
  }


  Future<UserModel?> login(String email, String password) async {
    if (_usersCollection == null) {
      _setupCollectionReferences();
    }

    try {
      QuerySnapshot querySnapshot = await _usersCollection!
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel data = doc.data() as UserModel;
        UserModel user = UserModel.fromJson(data.toJson());
        if(email == user.email && password == user.password){
          UserModel userWithoutPassword = UserModel(
            firstName: user.firstName,
            lastName: user.lastName,
            gender: user.gender,
            urlAvatar: user.urlAvatar,
            email: user.email,
            role: user.role,
            isHasProfile: user.isHasProfile
          );
          return userWithoutPassword;
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  Future<bool> addBlog(String id, String title, String image, String category, String description) async {
    BlogModel data = BlogModel(
      id: id,
      title: title,
      image: image,
      category: category,
      description: description,
      status: '1'
    );
    if (_blogsCollection == null) {
      _setupCollectionReferences();
    }
    try {
      final querry = await checkBlogExist(id);
      print(querry);
      if(querry){
        return false;
      }
      await _blogsCollection?.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(String name, String code, double price, int quantity, String category, String description, List<String?> urlImages) async {
    ProductModel data = ProductModel(
      name: name,
      code: code,
      price: price,
      quantity: quantity,
      category: category,
      description: description,
      urlImages: urlImages,
      status: '1',
    );
    print(data.description);
    if (_productsCollection == null) {
      _setupCollectionReferences();
    }
    try {
      final querry = await checkProductExist(code);
      if(querry){
        return false;
      }
      await _productsCollection?.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addUser(String email, String password) async {
    if(email == null || password == null || email.isEmpty || password.isEmpty)
      return false;
    UserModel user = UserModel(
      email: email,
      gender: null,
      urlAvatar: null,
      firstName: null,
      lastName: null,
      password: password,
      isHasProfile: false,
      role: null,
    );
    if (_usersCollection == null) {
          _setupCollectionReferences();
    }
    try {
      final querry = await getUser(email);
      if(querry){
        return false;
      }
      await _usersCollection?.add(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createProfile(String email, String url, String firstName, String lastName, String gender, String role) async {
    if (_usersCollection == null) {
      _setupCollectionReferences();
    }
    try{
      QuerySnapshot querySnapshot = await _usersCollection!
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        await doc.reference.update({
          'urlAvatar': url,
          'firstName': firstName,
          'isHasProfile': true,
          'lastName': lastName,
          'gender': gender,
          'role': role,
        });
        return true;
      } else {
        return false;
      }
    } catch(e){
      print(e);
      return false;
    }
  }

  Stream<List<ProductModel>> getProductCollection() {
    CollectionReference products = FirebaseFirestore.instance.collection('products');
    return products.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<BlogModel>> getBlogCollection() {
    CollectionReference products = FirebaseFirestore.instance.collection('blogs');
    return products.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return BlogModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<UserModel> getUserProfile(String email) async {
    if (_usersCollection == null) {
      _setupCollectionReferences();
    }
    try {
      QuerySnapshot querySnapshot = await _usersCollection!
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel data = doc.data() as UserModel;
        UserModel user = UserModel.fromJson(data.toJson());
        if(email == user.email){
          UserModel userWithoutPassword = UserModel(
              firstName: user.firstName,
              lastName: user.lastName,
              gender: user.gender,
              urlAvatar: user.urlAvatar,
              email: user.email,
              role: user.role,
              isHasProfile: user.isHasProfile
          );
          return userWithoutPassword;
        }
        return UserModel();
      } else {
        return UserModel();
      }
    } catch (e) {
      print("Error: $e");
      return UserModel();
    }
  }

}
