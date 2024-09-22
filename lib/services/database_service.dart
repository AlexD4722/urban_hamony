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

  Future<bool> checkProductExist(String code) async {
    try{
      QuerySnapshot querySnapshot = await _usersCollection!
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
        print("Không tìm thấy người dùng!");
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      return null;
    }
  }

  // Future<bool> addBlog(String id, String title, String image, String category, String description, String status) async {
  //   BlogModel data = BlogModel(
  //     // id: ,
  //     // title: ,
  //     // image: ,
  //     // category: ,
  //     // description: ,
  //     // status: ,
  //   );
  //   print(data);
  //   if (_productsCollection == null) {
  //     _setupCollectionReferences();
  //   }
  //   try {
  //     final querry = await checkProductExist(code);
  //     if(querry){
  //       return false;
  //     }
  //     await _productsCollection?.add(data);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> addProduct(String name, String code, String price, String quantity, String category, String description, List<String?> urlImages) async {
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
    print(data);
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

  // Future<bool> checkChatRoomExists(String uid1, String uid2) async {
  //   String chatID = generateChatID(uid1: uid1, uid2: uid2);
  //   final result = await _chatsCollection?.doc(chatID).get();
  //   if (result != null) {
  //     return result.exists;
  //   }
  //   return false;
  // }

  // Future<void> createChatRoom(NotificationModel data) async {
  //   print(data.id);
  //   String chatID = generateChatID(uid1: data.receiverId.toString(), uid2: data.senderId.toString());
  //   if (_chatsCollection == null) {
  //     _setupCollectionReferences();
  //   }
  //   final docRef = _chatsCollection!.doc(chatID);
  //   List<Participants> participants = [
  //     Participants(
  //         fullname: data.senderName,
  //         id: data.senderId.toString(),
  //         images: data.senderImage
  //     ),
  //     Participants(
  //         fullname: data.receiverName,
  //         id: data.receiverId.toString(),
  //         images: data.receiverImage
  //     ),
  //
  //   ];
  //   final chat = ChatRoomModel(
  //       id: data.idMatching2.toString(),
  //       participants: participants,
  //       newMessage: [],
  //       messages: [],
  //       contain: [data.senderId.toString(),data.receiverId.toString()]
  //   );
  //   print(chat);
  //   await docRef.set(chat);
  // }

  // String generateChatID({required String uid1, required String uid2}) {
  //   List uids = [uid1, uid2];
  //   uids.sort();
  //   String chatID = uids.fold("", (id, uid) => "$id$uid");
  //   return chatID;
  // }

  // Future<void> sendChatMessage(String uid1, String uid2,
  //     Message message) async {
  //   String chatID = generateChatID(uid1: uid1, uid2: uid2);
  //   // if (_chatsCollection == null) {
  //   //   await _setupCollectionReferences();
  //   // }
  //   final docRef = await _chatsCollection!.doc(chatID);
  //   await docRef.update({
  //     'messages': FieldValue.arrayUnion(
  //       [
  //         message.toJson(),
  //       ],
  //     ),
  //     'newMessage': [message.toJson()],
  //   });
  // }

  // Future<void> updateStatus(String uid1, String uid2) async {
  //   String chatID = generateChatID(uid1: uid1, uid2: uid2);
  //   if (_chatsCollection == null) {
  //     _setupCollectionReferences();
  //   }
  //   final docRef = await _chatsCollection!.doc(chatID);
  //   final docSnapshot = await docRef.get();
  //   if (docSnapshot.exists) {
  //     List<dynamic> messages = docSnapshot.get('messages');
  //     List<dynamic> newMessages = docSnapshot.get('newMessage');
  //
  //     // Update the 'seen' field for messages sent by the user with senderID == uid2
  //     List<Map<String, dynamic>> updatedNewMessages = newMessages.map((nmsg) {
  //       if (nmsg is Map<String, dynamic>) {
  //         if (nmsg['senderID'] == uid2) {
  //           nmsg['seen'] = true;
  //         }
  //         return nmsg;
  //       }
  //       return nmsg as Map<String, dynamic>;
  //     }).toList();
  //
  //     List<Map<String, dynamic>> updatedMessages = messages.map((msg) {
  //       if (msg is Map<String, dynamic>) {
  //         if (msg['senderID'] == uid2) {
  //           msg['seen'] = true;
  //         }
  //         return msg;
  //       }
  //       return msg as Map<String, dynamic>;
  //     }).toList();
  //     await docRef.update({
  //       'messages': updatedMessages,
  //       'newMessage': updatedNewMessages,
  //     });
  //   }
  // }

  // Stream getChatData(String uid1, String uid2) {
  //   String chatID = generateChatID(uid1: uid1, uid2: uid2);
  //   if (_chatsCollection == null) {
  //     _setupCollectionReferences();
  //   }
  //   return _chatsCollection!.doc(chatID).snapshots() as Stream<DocumentSnapshot<ChatRoomModel>>;
  // }


  // Stream getListChatRooms(String userId) {
  //   if (_chatsCollection == null) {
  //     _setupCollectionReferences();
  //   }
  //   return _chatsCollection!
  //       .where('participants', arrayContains: userId)
  //       .snapshots();
  // }

  // Stream<List<ChatRoomModel>> getListChatRooms(String userId) {
  //   Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshots = _firebaseFirestore.collection('chats')
  //       .where('contain', arrayContains: userId)
  //       .snapshots();
  //   return querySnapshots.map((q) {
  //     List<ChatRoomModel> chatboxes = q.docs.map((doc) {
  //       return ChatRoomModel.fromJson(doc.data());
  //     }).toList();
  //
  //     // Sắp xếp các chatboxes theo `sentAt` mới nhất trong `newMessage`
  //     chatboxes.sort((a, b) {
  //       Timestamp? sentAtA = a.newMessage != null && a.newMessage!.isNotEmpty
  //           ? a.newMessage!.last.sentAt
  //           : Timestamp.fromMillisecondsSinceEpoch(0);
  //       Timestamp? sentAtB = b.newMessage != null && b.newMessage!.isNotEmpty
  //           ? b.newMessage!.last.sentAt
  //           : Timestamp.fromMillisecondsSinceEpoch(0);
  //
  //       return sentAtB!.compareTo(sentAtA!); // Sắp xếp giảm dần theo thời gian
  //     });
  //     return chatboxes;
  //   });
  // }
}
