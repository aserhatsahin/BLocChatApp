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

    final docRef =
        firestore.collection('chats').doc(chatId).collection('messages').doc();

    final messageId = docRef.id;

    final newMessage = MessageModel(
      messageId: messageId,
      message: message,
      senderId: currentUserUid,
      receiverId: receiverUid,
      sendedAt: DateTime.now(),
      isEdited: false,
    );

    await docRef.set(newMessage.toEntity().toDocument());

    await firestore.collection('chats').doc(chatId).set(
      {
        'lastMessage': message,
        'lastMessageTime': Timestamp.fromDate(newMessage.sendedAt),
        'lastMessageSenderId': currentUserUid,
      },
      SetOptions(merge: true),
    );
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
      final senderSnap =
          await firestore.collection('users').doc(senderUid).get();
      final receiverSnap =
          await firestore.collection('users').doc(otherUid).get();

      final senderName = senderSnap.data()?['username'] ?? 'Unknown';
      final receiverName = receiverSnap.data()?['username'] ?? 'Unknown';

      await firestore.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'participantIds': [senderUid, otherUid],
        'participantNames': [senderName, receiverName],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': Timestamp.fromDate(DateTime.now()),
        'lastMessageSenderId': '',
      });
    }
  }

  @override
  Future<void> updateTypingStatus(String receiverUid, bool isTyping) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    final currentUserUid = currentUser.uid;
    final chatId = _generateChatId(currentUserUid, receiverUid);
    final fieldName = 'typing_$currentUserUid';

    await firestore.collection('chats').doc(chatId).set(
      {fieldName: isTyping},
      SetOptions(merge: true),
    );
  }

  @override
  Stream<bool> listenTypingStatus(String receiverUid) {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      return Stream<bool>.value(false);
    }

    final currentUserUid = currentUser.uid;
    final chatId = _generateChatId(currentUserUid, receiverUid);
    final fieldName = 'typing_$receiverUid';

    return firestore.collection('chats').doc(chatId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return false;
      final value = data[fieldName];
      if (value is bool) {
        return value;
      }
      return false;
    });
  }

  @override
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    final messagesCollection =
        firestore.collection('chats').doc(chatId).collection('messages');

    await messagesCollection.doc(messageId).delete();

    final latestSnapshot = await messagesCollection
        .orderBy('sendedAt', descending: true)
        .limit(1)
        .get();

    if (latestSnapshot.docs.isEmpty) {
      // Hiç mesaj kalmadıysa chat özetini temizle
      await firestore.collection('chats').doc(chatId).set(
        {
          'lastMessage': '',
          'lastMessageTime': Timestamp.fromDate(DateTime.now()),
          'lastMessageSenderId': '',
        },
        SetOptions(merge: true),
      );
    } else {
      final doc = latestSnapshot.docs.first;
      final data = doc.data();
      await firestore.collection('chats').doc(chatId).set(
        {
          'lastMessage': data['message'] as String? ?? '',
          'lastMessageTime': data['sendedAt'] as Timestamp? ??
              Timestamp.fromDate(DateTime.now()),
          'lastMessageSenderId': data['senderId'] as String? ?? '',
        },
        SetOptions(merge: true),
      );
    }
  }

  @override
  Future<void> editMessage({
    required String chatId,
    required String messageId,
    required String newText,
  }) async {
    final messageRef = firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    final messageSnap = await messageRef.get();
    if (!messageSnap.exists) {
      return;
    }

    final data = messageSnap.data() as Map<String, dynamic>? ?? {};

    await messageRef.update({
      'message': newText,
      'isEdited': true,
    });

    // Eğer bu mesaj en son mesajsa, chat özetini de güncelle
    final latestSnapshot = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sendedAt', descending: true)
        .limit(1)
        .get();

    if (latestSnapshot.docs.isNotEmpty &&
        latestSnapshot.docs.first.id == messageId) {
      await firestore.collection('chats').doc(chatId).set(
        {
          'lastMessage': newText,
          'lastMessageTime': data['sendedAt'] as Timestamp? ??
              Timestamp.fromDate(DateTime.now()),
          'lastMessageSenderId': data['senderId'] as String? ?? '',
        },
        SetOptions(merge: true),
      );
    }
  }
}