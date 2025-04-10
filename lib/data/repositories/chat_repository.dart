import 'package:bloc_chatapp/data/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatRepository {
  Stream<ChatModel?> get chatModel;

  Future<void> sendMessage(String username, String message);

  Stream<QuerySnapshot> getChatData(String uid);


Stream<List<ChatModel>>  getUserChats(String uid);


Future<void> createChatIfNotExist(String uid);
 
}
