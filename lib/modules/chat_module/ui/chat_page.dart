import 'dart:developer';
import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/chat/firebase_chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_event.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/send_message/send_message_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/ui/widgets/message_input_widget.dart';
import 'package:bloc_chatapp/modules/chat_module/ui/widgets/message_list_widget.dart';
import 'package:bloc_chatapp/modules/profile_module/ui/profile_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPageView extends StatelessWidget {
  final String receiverUid;
  final String receiverUsername;

  const ChatPageView({super.key, required this.receiverUid, required this.receiverUsername});

  String _generateChatId(String user1, String user2) {
    final List<String> uids = [user1, user2]..sort();
    return "${uids[0]}-${uids[1]}";
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final chatId = _generateChatId(currentUser.uid, receiverUid);

    return FutureBuilder<UserModel>(
      future: context.read<UserRepository>().getUserData(currentUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Kullanıcı verileri alınamadı')));
        }
        final user = snapshot.data!;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (context) =>
                      ListenMessageBloc(chatRepository: context.read<ChatRepository>())
                        ..add(ListenMessagesRequested(chatId: chatId)),
            ),
            BlocProvider(
              create: (context) => SendMessageBloc(chatRepository: context.read<ChatRepository>()),
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: FutureBuilder<UserModel>(
                future: context.read<UserRepository>().getUserData(receiverUid),
                builder: (context, snapshot) {
                  String imageUrl = '';
                  if (snapshot.hasData) {
                    imageUrl = snapshot.data!.imageUrl;
                  }
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            imageUrl.isNotEmpty && imageUrl != 'No Image'
                                ? NetworkImage(imageUrl)
                                : null,
                        backgroundColor: AppColors.grey,
                        child:
                            imageUrl.isEmpty || imageUrl == 'No Image'
                                ? Icon(Icons.person, color: AppColors.white, size: 16)
                                : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        receiverUsername,
                        style: TextStyle(color: AppColors.white, fontSize: AppStyles.textLarge),
                      ),
                    ],
                  );
                },
              ),
              backgroundColor: const Color.fromARGB(218, 170, 196, 172),
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: () {
                    log('Navigating to ProfilePageView for user: ${user.uid}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePageView(user: user)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          user.imageUrl.isNotEmpty && user.imageUrl != 'No Image'
                              ? NetworkImage(user.imageUrl)
                              : null,
                      backgroundColor: AppColors.grey,
                      child:
                          user.imageUrl.isEmpty || user.imageUrl == 'No Image'
                              ? Icon(Icons.person, color: AppColors.white)
                              : null,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(child: MessageListWidget(receiverUid: receiverUid, chatId: chatId)),
                MessageInputWidget(receiverUid: receiverUid),
              ],
            ),
          ),
        );
      },
    );
  }
}
