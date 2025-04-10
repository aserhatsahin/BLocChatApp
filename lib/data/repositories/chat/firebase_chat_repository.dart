

import 'package:bloc_chatapp/data/entitites/chat_entity.dart';
import 'package:bloc_chatapp/data/models/chat_model.dart';
import 'package:bloc_chatapp/data/models/message_model.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseChatRepository extends ChatRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<ChatModel?> get chatModel => throw UnimplementedError();

  @override
  Stream<QuerySnapshot> getChatData(String receiverUid) {
    final currentUserUid = auth.currentUser!.uid;
    final chatId = "$currentUserUid-$receiverUid";

    return firestore.collection('chats').doc(chatId).collection('messages').snapshots();
  }

  @override
  Future<void> sendMessage(String receiverUid, String message) async {
    final currentUser = auth.currentUser!;
    final currentUserUid = currentUser.uid;
    final chatId = "$currentUserUid-$receiverUid";

    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(
          MessageModel(
            message: message,
            receiverId: receiverUid,
            senderId: currentUserUid,
            sendedAt: DateTime.now(),
          ).toEntity().toDocument(),
        );

    await firestore.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': DateTime.now(),
    });
  }

  @override
  Stream<List<ChatModel>> getUserChats(String uid) {


    return firestore
        .collection('chats')
        .where('participantIds', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ChatModel.fromEntity(ChatEntity.fromDocument(doc.data()));
          }).toList();
        });
  }

  @override
  Future<void> createChatIfNotExist(String otherUid) async {
    final senderUid = auth.currentUser!.uid;
    final chatId = '$senderUid-$otherUid';

    final chatDoc = await firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      final senderSnap = await firestore.collection('users').doc(senderUid).get();
      final receiverSnap = await firestore.collection('users').doc(otherUid).get();

      final senderName = senderSnap.data()?['username'] ?? 'Unknown';
      final receiverName = receiverSnap.data()?['username'] ?? 'Unknown';

      await firestore.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'participantIds': [senderUid, otherUid],
        'participantNames': [senderName, receiverName],
        'createdAt': DateTime.now(),
        'lastMessage': '',
        'lastMessageTime': DateTime.now(),
      });
    }
  }
}
