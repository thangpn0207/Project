import 'dart:async';

import 'package:app_web_project/core/containts/spref_constants.dart';
import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/image_model.dart';
import 'package:app_web_project/core/model/song.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/utils/spref_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Repository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//user
  Future<UserModel?> searchUserByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> snapShot = await _firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .get();
    var userId = await SPrefUtil.instance.getString(SPrefConstants.userId);
    final data = snapShot.docs[0];
    if (data['id'] != userId) {
      UserModel userModel = UserModel(
        id: data['id'],
        email: data['email'],
        displayName: data['displayName'],
        imgUrl: data['imgUrl'],
        location: data['location'] != null ? data['location'] : '',
        phone: data['phone'] != null ? data['phone'] : '',
        age: data['age'] != null ? data['age'] : '',
        photos: data['photo'] != null ? data['photo'] : '',
      );
      return userModel;
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> searchUserByName(String email) {
    return _firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email.toLowerCase())
        .snapshots();
  }

  Stream<List<UserModel>> searchUserInfo(displayName) {
    return searchUserByName(displayName)
        .transform(documentToUserInfoTransformer);
  }

  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<UserModel>>
      documentToUserInfoTransformer = StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>,
              List<UserModel>>.fromHandlers(
          handleData: (QuerySnapshot<Map<String, dynamic>> snapShot,
              EventSink<List<UserModel>> sink) async {
    List<UserModel> result = <UserModel>[];
    var userId = await SPrefUtil.instance.getString(SPrefConstants.userId);
    snapShot.docs.forEach((doc) {
      if (userId != doc['id']) {
        result.add(UserModel(
          id: doc['id'],
          email: doc['email'],
          displayName: doc['displayName'],
          imgUrl: doc['imgUrl'],
          location: doc['location'] != null ? doc['location'] : '',
          phone: doc['phone'] != null ? doc['phone'] : '',
          age: doc['age'] != null ? doc['age'] : '',
          photos: doc['photo'] != null ? doc['photo'] : '',
        ));
      } else {
        print('object');
      }
    });
    sink.add(result);
  });

  Stream<QuerySnapshot> getPhotoUser(String userId) {
    return _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('photos')
        // .orderBy('imageTs', descending: false)
        .snapshots();
  }

  Stream<List<ImageModel>> getListPhotos(String userId) {
    return getPhotoUser(userId).transform(documentToImageTransformer);
  }

  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<ImageModel>>
      documentToImageTransformer = StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>,
              List<ImageModel>>.fromHandlers(
          handleData: (QuerySnapshot<Map<String, dynamic>> snapShot,
              EventSink<List<ImageModel>> sink) async {
    List<ImageModel> result = <ImageModel>[];
    snapShot.docs.forEach((doc) {
      ImageModel image =
          ImageModel(imageTs: doc['imageTs'], imageUrl: doc['imgUrl']);
      result.add(image);
    });
    sink.add(result);
  });

  Future<void> sendPhotoToDb(
      String userId, ImageModel imageModel, int photoNumber) async {
    try {
      var reference = _firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('photos')
          .doc(imageModel.imageTs);
      await _firebaseFirestore.runTransaction((transaction) async {
        transaction.set(reference, {
          'imageTs': imageModel.imageTs,
          'imgUrl': imageModel.imageUrl,
        });
      });
      int photos = photoNumber + 1;
      await _firebaseFirestore.collection('users').doc(userId).update({
        'photo': photos,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUserToken(userID, token) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).update({
      'FCMToken': token,
    });
  }

  Future<UserModel?> getUser(String? id) async {
    var doc = await _firebaseFirestore.collection('users').doc(id).get();
    final data = doc.data();
    if (data != null) {
      return UserModel(
        id: data['id'],
        email: data['email'],
        displayName: data['displayName'],
        imgUrl: data['imgUrl'],
        location: data['location'] != null ? data['location'] : '',
        phone: data['phone'] != null ? data['phone'] : '',
        age: data['age'] != null ? data['age'] : '',
        photos: data['photo'] != null ? data['photo'] : 0,
      );
    } else {
      return null;
    }
  }

  Future<bool> checkUser(String? id) async {
    var doc = await _firebaseFirestore.collection('users').doc(id).get();
    if (doc.data() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> registerUser(UserModel user) async {
    _firebaseFirestore.collection('users').doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'imgUrl': user.imgUrl,
      'location': '',
      'phone': '',
      'age': '',
      'photo': 0,
    });
  }

  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return _firebaseFirestore.collection("users").doc(userId).set(userInfoMap);
  }

  Future<void> updateUserInfo(UserModel userModel) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(userModel.id)
        .update({
      "id": userModel.id,
      'imgUrl': userModel.imgUrl,
      "email": userModel.email,
      "displayName": userModel.displayName,
      'location': userModel.location,
      'phone': userModel.phone,
      'age': userModel.age,
    });
  }

  //get chat room
  Future<void> setChatRoom(ChatRoom chatRoomInfo) async {
    return await _firebaseFirestore
        .collection('chatRooms')
        .doc(chatRoomInfo.id)
        .set(chatRoomInfo.toJson());
  }

  // Future<DocumentSnapshot> getChatRoom(String chatRoomId) async {
  //   return await _firebaseFirestore.collection('chatRooms').doc(chatRoomId).get();
  // }

  Future<void> updateUserChatList(String? userId, String chatRoomId) async {
    var chatListDoc =
        await _firebaseFirestore.collection('userAndChats').doc(userId).get();
    if (chatListDoc.exists) {
      return chatListDoc.reference.update({chatRoomId: true});
    } else {
      return chatListDoc.reference.set({chatRoomId: true});
    }
  }

  Future<void> deleteChatRoom(String? userId, String chatRoomId) async {
    var chatListDoc =
        await _firebaseFirestore.collection('userAndChats').doc(userId).get();
    return chatListDoc.reference.update({chatRoomId: false});
  }

  Stream<DocumentSnapshot> getChatList(String id) {
    return _firebaseFirestore.collection('userAndChats').doc(id).snapshots();
  }

  Stream<QuerySnapshot> getChatMessages(String chatRoomId) {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('lastMessageTs', descending: false)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getChatRoom(
      String chatRoomId) async {
    return await _firebaseFirestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .get();
  }

  Stream<QuerySnapshot> getChatRoomInfo(List<String> chatId) {
    return _firebaseFirestore
        .collection('chatRooms')
        .where('id', whereIn: chatId)
        .snapshots();
  }

  Future<Map<String, dynamic>?> sendChatMessage(
      String chatRoomId, ChatMessage chatMessage) async {
    var reference = _firebaseFirestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(chatMessage.lastMessageTs);

    return _firebaseFirestore.runTransaction((transaction) async {
      transaction.set(reference, {
        'type': chatMessage.type,
        'message': chatMessage.message,
        'lastMessageTs': chatMessage.lastMessageTs,
        'sendBy': chatMessage.sendBy,
      });
    });
  }

  Future<void> deleteMessage(String chatRoomId, ChatMessage chatMessage) {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(chatMessage.lastMessageTs)
        .delete();
  }

  Future<Map<String, dynamic>?> setChatRoomLastMessage(
      String chatRoomId, ChatMessage chatMessage) async {
    var reference = _firebaseFirestore.collection('chatRooms').doc(chatRoomId);

    return _firebaseFirestore.runTransaction((transaction) async {
      transaction.update(reference, {
        'lastMessage':
            chatMessage.type == 'text' ? chatMessage.message : 'Photo',
        'lastMessageTs': chatMessage.lastMessageTs,
        'lastMessageBy': chatMessage.sendBy,
        'lastMessageType': chatMessage.type,
      });
    });
  }

//song
  Future<void> uploadSongToChatRoom(Song song, String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('songs')
        .doc(song.songName)
        .set(song.toJson())
        .whenComplete(() => print('upload success'));
  }

  Stream<QuerySnapshot> getSongInChatRoom(String chatRoomId) {
    return _firebaseFirestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('songs')
        .orderBy('songName', descending: false)
        .snapshots();
  }

  Future<String?> sendImageToUserInChatRoom(croppedFile, chatID) async {
    try {
      String imageTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'chatrooms/$chatID/$imageTimeStamp';
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref(filePath)
            .putFile(croppedFile);
      } on firebase_core.FirebaseException catch (e) {
        print('upload image exception, code is ${e.code}');
        return null;
        // e.g, e.code == 'canceled'
      }
      return await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> sendImageToUserInChatRoomWeb(croppedFile, chatID) async {
    try {
      String imageTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'chatrooms/$chatID/$imageTimeStamp';
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref(filePath)
            .putData(croppedFile);
      } on firebase_core.FirebaseException catch (e) {
        print('upload image exception, code is ${e.code}');
        return null;
        // e.g, e.code == 'canceled'
      }
      return await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> sendImgToDB(croppedFile) async {
    try {
      String imageTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'user/$imageTimeStamp';
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref(filePath)
            .putFile(croppedFile);
      } on firebase_core.FirebaseException catch (e) {
        print('upload image exception, code is ${e.code}');
        return null;
        // e.g, e.code == 'canceled'
      }
      return await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> sendImgToDBWeb(croppedFile) async {
    try {
      String imageTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'user/$imageTimeStamp';
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref(filePath)
            .putData(croppedFile);
      } on firebase_core.FirebaseException catch (e) {
        print('upload image exception, code is ${e.code}');
        return null;
        // e.g, e.code == 'canceled'
      }
      return await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> uploadFileSong(file, String chatID, String fileName,
      String nameSong, String nameSinger) async {
    try {
      try {
        await firebase_storage.FirebaseStorage.instance
            .ref('upload/$fileName')
            .putData(file);
      } on firebase_core.FirebaseException catch (e) {
        print('upload image exception, code is ${e.code}');
        // e.g, e.code == 'canceled'
      }
      String dowUrl = await firebase_storage.FirebaseStorage.instance
          .ref('upload/$fileName')
          .getDownloadURL();
      Song dataSong =
          new Song(songUrl: dowUrl, songName: nameSong, singerName: nameSinger);
      await uploadSongToChatRoom(dataSong, chatID);
    } catch (e) {}
  }
}
