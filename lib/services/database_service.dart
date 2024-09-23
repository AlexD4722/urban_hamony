import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urban_hamony/models/auth_model.dart';
import 'package:urban_hamony/models/product_model.dart';

import '../models/blog_model.dart';
import '../models/design.dart';
import '../utils/userInfoUtil.dart';

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

  Future<String> getEmailUser() async {
    UserModel? currentUser = await UserinfoUtil.getCurrentUser();
    String email =
        currentUser!.email ?? ""; // Replace with the current user's email
    return email;
  }

  Stream<List<Design>> getDesignsByEmail(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .where('email', isEqualTo: email)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        return user.listDesign ?? [];
      } else {
        return [];
      }
    });
  }

  Future<void> updateProductStatusByCode(String code, String status) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('products')
          .where('code', isEqualTo: code)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference productRef = querySnapshot.docs.first.reference;
        await productRef.update({'status': status});
      } else {
        print('Document not found: $code');
      }
    } catch (e) {
      print('Error updating product status: $e');
    }
  }
  Stream<List<Design>> getAllDesignsWithStatus2() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.snapshots().map((querySnapshot) {
      List<Design> designsWithStatus2 = [];
      for (var doc in querySnapshot.docs) {
        UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        designsWithStatus2.addAll(user.listDesign?.where((design) => design.status == 2).toList() ?? []);
      }
      return designsWithStatus2;
    });
  }
  Future<void>  updateDesignInUser(String email, Design updatedDesign) async {
    try {
      // Fetch the user document
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userRef = querySnapshot.docs.first.reference;
        UserModel user = UserModel.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);

        // Find the index of the design to be updated
        int designIndex = user.listDesign?.indexWhere((design) => design.id == updatedDesign.id) ?? -1;

        if (designIndex != -1) {
          // Update the design in the list
          user.listDesign![designIndex] = updatedDesign;

          // Save the updated user document back to Firestore
          await userRef.update(user.toJson());
        } else {
          print('Design not found in user\'s listDesign');
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error updating design in user: $e');
    }
  }

  Future<bool> getUser(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection!.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel data = doc.data() as UserModel;
        UserModel user = UserModel.fromJson(data.toJson());
        if (user.email == email) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveDesignToUser(String email, Design design) async {
    if (_usersCollection == null) {
      _setupCollectionReferences();
    }
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection!.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel user = doc.data() as UserModel;
        user.listDesign ??= [];
        user.listDesign!.add(design);
        await doc.reference.update(user.toJson());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkBlogExist(String code) async {
    try {
      QuerySnapshot querySnapshot =
          await _blogsCollection!.where('id', isEqualTo: code).get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        BlogModel data = doc.data() as BlogModel;
        BlogModel blog = BlogModel.fromJson(data.toJson());
        if (blog.id == code) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkProductExist(String code) async {
    try {
      QuerySnapshot querySnapshot =
          await _productsCollection!.where('code', isEqualTo: code).get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        ProductModel data = doc.data() as ProductModel;
        ProductModel product = ProductModel.fromJson(data.toJson());
        if (product.code == code) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> login(String email, String password) async {
    if (_usersCollection == null) {
      _setupCollectionReferences();
    }

    try {
      QuerySnapshot querySnapshot =
          await _usersCollection!.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel data = doc.data() as UserModel;
        UserModel user = UserModel.fromJson(data.toJson());
        if (email == user.email && password == user.password) {
          UserModel userWithoutPassword = UserModel(
              firstName: user.firstName,
              lastName: user.lastName,
              gender: user.gender,
              urlAvatar: user.urlAvatar,
              email: user.email,
              role: user.role,
              isHasProfile: user.isHasProfile);
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

  Future<bool> addBlog(String id, String title, String image, String category,
      String description, String html) async {
    BlogModel data = BlogModel(
        id: id,
        title: title,
        image: image,
        category: category,
        description: description,
        status: '1');
    if (_blogsCollection == null) {
      _setupCollectionReferences();
    }
    try {
      final querry = await checkBlogExist(id);
      print(querry);
      if (querry) {
        return false;
      }
      await _blogsCollection?.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(String name, String code, double price, int quantity,
      String category, String description, List<String?> urlImages) async {
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
    if (_productsCollection == null) {
      _setupCollectionReferences();
    }
    try {
      final querry = await checkProductExist(code);
      if (querry) {
        return false;
      }
      await _productsCollection?.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addUser(String email, String password) async {
    if (email == null || password == null || email.isEmpty || password.isEmpty)
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
      if (querry) {
        return false;
      }
      await _usersCollection?.add(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createProfile(String email, String url, String firstName,
      String lastName, String gender, String role) async {
    if (_usersCollection == null) {
      _setupCollectionReferences();
    }
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection!.where('email', isEqualTo: email).get();
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
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<ProductModel>> getProductCollection() {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    return products.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<BlogModel>> getBlogCollection() {
    CollectionReference products =
        FirebaseFirestore.instance.collection('blogs');
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
      QuerySnapshot querySnapshot =
          await _usersCollection!.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = querySnapshot.docs.first;
        UserModel data = doc.data() as UserModel;
        UserModel user = UserModel.fromJson(data.toJson());
        if (email == user.email) {
          UserModel userWithoutPassword = UserModel(
              firstName: user.firstName,
              lastName: user.lastName,
              gender: user.gender,
              urlAvatar: user.urlAvatar,
              email: user.email,
              role: user.role,
              isHasProfile: user.isHasProfile);
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
