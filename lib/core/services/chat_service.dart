import 'dart:async';
import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:app_web_project/core/model/chat_message.dart';
import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/services/repository_service.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class ChatService {
  final Repository _repository;

  ChatService(this._repository);

  Future<String> addChatRoom(
      UserModel user, UserModel friendUser, String roomName) async {
    String chatRoomId = randomAlphaNumeric(13);
    var chatRoomInfo = await _repository.getChatRoom(chatRoomId);
    if (chatRoomInfo.exists) {
      return chatRoomId;
    } else {
      ChatRoom newRoomInfo = ChatRoom(
        id: chatRoomId,
        title: roomName,
        imgUrl: friendUser.imgUrl,
        lastMessageBy: '',
        lastMessage: '',
        lastMessageTs: DateTime.now().millisecondsSinceEpoch.toString(),
        lastMessageType: '',
      );
      await _repository.setChatRoom(newRoomInfo);
      await _repository.updateUserChatList(user.id, chatRoomId);
      await _repository.updateUserChatList(friendUser.id, chatRoomId);
    }
    return chatRoomId;
  }

  Stream<List<ChatRoom>> getChatRoomInfo(List<String> userId) {
    return _repository
        .getChatRoomInfo(userId)
        .transform(documentToChatRoomInfoTransformer);
  }

  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<ChatRoom>>
      documentToChatRoomInfoTransformer = StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>, List<ChatRoom>>.fromHandlers(
          handleData: (QuerySnapshot<Map<String, dynamic>> snapShot,
              EventSink<List<ChatRoom>> sink) {
    List<ChatRoom> result = <ChatRoom>[];
    snapShot.docs.forEach((doc) {
      result.add(ChatRoom(
        id: doc['id'],
        title: doc['title'],
        imgUrl: doc['imgUrl'],
        lastMessageBy: doc['lastMessageBy'],
        lastMessageTs: doc['lastMessageTs'],
        lastMessage: doc['lastMessage'],
        lastMessageType: doc['lastMessageType'],
      ));
    });
    sink.add(result);
  });

  Stream<List<String>> getChatList(userId) {
    return _repository
        .getChatList(userId)
        .transform(documentToChatListTransformer);
  }

  StreamTransformer<DocumentSnapshot<Map<String, dynamic>>, List<String>>
      documentToChatListTransformer = StreamTransformer<
              DocumentSnapshot<Map<String, dynamic>>,
              List<String>>.fromHandlers(
          handleData: (DocumentSnapshot<Map<String, dynamic>> snapShot,
              EventSink<List<String>> sink) {
    if (snapShot.exists) {
      List<String> result = <String>[];
      snapShot.data()!.keys.forEach((element) {
        if (snapShot.data()![element] == true) {
          result.add(element);
        }
      });
      sink.add(result);
    } else {
      sink.add([]);
    }
  });
  Future<void> deleteChatRoom(String? userId, String chatRoomId) async {
    return await _repository.deleteChatRoom(userId, chatRoomId);
  }

  Stream<List<ChatMessage>> getChatMessages(String chatRoomId) {
    return _repository
        .getChatMessages(chatRoomId)
        .transform(documentToChatMessagesTransformer);
  }

  StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<ChatMessage>>
      documentToChatMessagesTransformer = StreamTransformer<
              QuerySnapshot<Map<String, dynamic>>,
              List<ChatMessage>>.fromHandlers(
          handleData: (QuerySnapshot<Map<String, dynamic>> snapShot,
              EventSink<List<ChatMessage>> sink) {
    List<ChatMessage> result = <ChatMessage>[];
    snapShot.docs.forEach((doc) {
      result.add(ChatMessage(
          type: doc['type'],
          message: utf8.decode(base64.decode(doc['message'])),
          sendBy: doc['sendBy'],
          lastMessageTs: doc['lastMessageTs']));
    });
    sink.add(result);
  });

  Future<Map<String, dynamic>?> sendChatMessage(
      String chatRoomId, ChatMessage chatMessage) async {
    return await _repository.sendChatMessage(chatRoomId, chatMessage);
  }

  Future<Map<String, dynamic>?> setChatRoomLastMessage(
      String chatRoomId, ChatMessage chatMessage) async {
    return await _repository.setChatRoomLastMessage(chatRoomId, chatMessage);
  }

  Future<void> deleteMessage(String chatRoomId, ChatMessage chatMessage) async {
    return await _repository.deleteMessage(chatRoomId, chatMessage);
  }

  Future<String?> sendPhotoMessage(croppedFile, chatID) async {
    return await _repository.sendImageToUserInChatRoom(croppedFile, chatID);
  }

  Future<String?> sendPhotoMessageFromWeb(croppedFile, chatID) async {
    return await _repository.sendImageToUserInChatRoomWeb(croppedFile, chatID);
  }
}
