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
  //to get the messsages in a chat
  Stream<QuerySnapshot> getChatData(String receiverUid) {
    User currentUser = auth.currentUser!;
    var currentUserUid = currentUser.uid;
    String chatId = "$currentUserUid-$receiverUid";

    return firestore.collection('chats').doc(chatId).collection('messages').snapshots();
  }

  @override
  Future<void> sendMessage(String receiverUid, String message) async {
    User currentUser = auth.currentUser!;

    var currentUserUid = currentUser.uid;

    String chatId = "$currentUserUid-$receiverUid";
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
  }

  //for listing all the chats of a user
  @override
  Stream<List<ChatModel>> getUserChats() {
    User currentUser = auth.currentUser!;

    var currentUserUid = currentUser.uid;
    return firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserUid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatModel.fromEntity(ChatEntity.fromDocument(doc.data())))
                  .toList(),
        );
  }

  @override
  Future<void> createChatIfNotExist(String uid) async {
    String senderUid = auth.currentUser!.uid;
    String chatId = '$senderUid-$uid';

    // Chat belgesinin var olup olmadığını kontrol et
    DocumentSnapshot chatDoc = await firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      // Eğer sohbet yoksa, yeni bir sohbet belgesi oluştur
      await firestore.collection('chats').doc(chatId).set({
        'participants': [senderUid, uid],
        'createdAt': DateTime.now(),
        // 'lastMessage': '', // Opsiyonel: Son mesajı saklamak için
      });
    }
  }
}
