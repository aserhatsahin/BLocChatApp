import 'package:bloc_chatapp/data/entitites/chat_entity.dart';
import 'package:bloc_chatapp/data/entitites/message_entity.dart';
import 'package:bloc_chatapp/data/models/chat_model.dart';
import 'package:bloc_chatapp/data/models/message_model.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseChatRepository extends ChatRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // chatId oluşturma: uid'leri alfabetik sıraya göre dizip birleştir
  String _generateChatId(String user1, String user2) {
    final List<String> uids = [user1, user2]..sort();
    return "${uids[0]}-${uids[1]}";
  }

  @override
  Stream<ChatModel?> get chatModel => throw UnimplementedError();

  @override
  Stream<QuerySnapshot> getChatData(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sendedAt', descending: true)
        .snapshots();
  }

  @override
  Future<void> sendMessage(String receiverUid, String message) async {
    final currentUser = auth.currentUser!;
    final currentUserUid = currentUser.uid;
    final chatId = _generateChatId(currentUserUid, receiverUid);

    await createChatIfNotExist(receiverUid);

    final docRef = firestore.collection('chats').doc(chatId).collection('messages').doc();

    final messageId = docRef.id;

    final newMessage = MessageModel(
      messageId: messageId,
      message: message,
      senderId: currentUserUid,
      receiverId: receiverUid,
      sendedAt: DateTime.now(),
    );

    await docRef.set(newMessage.toEntity().toDocument());

    await firestore.collection('chats').doc(chatId).set({
      'lastMessage': message,
      'lastMessageTime': Timestamp.fromDate(newMessage.sendedAt),
    }, SetOptions(merge: true));
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
    final chatId = _generateChatId(senderUid, otherUid);

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
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': Timestamp.fromDate(DateTime.now()),
      });
    }
  }
}