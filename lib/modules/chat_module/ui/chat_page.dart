import 'dart:developer';
import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';

import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_event.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/send_message/send_message_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/typing_indicator/typing_indicator_bloc.dart';
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
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Kullanıcı Doğrulama Hatası')));
    }

    final chatId = _generateChatId(currentUser.uid, receiverUid);

    return StreamBuilder<UserModel>(
      stream: context.read<UserRepository>().streamUserData(currentUser.uid),
      initialData: UserModel.empty, // Başlangıçta boş bir UserModel
      builder: (context, currentUserSnapshot) {
        UserModel currentUser = UserModel.empty;
        if (currentUserSnapshot.hasData) {
          currentUser = currentUserSnapshot.data!;
        } else if (currentUserSnapshot.hasError) {
          log('Current user stream hatası: ${currentUserSnapshot.error}');
          return const Scaffold(body: Center(child: Text('Kullanıcı verisi yüklenemedi')));
        }

        return StreamBuilder<UserModel>(
          stream: context.read<UserRepository>().streamUserData(receiverUid),
          initialData: UserModel(
            uid: receiverUid,
            username: receiverUsername,
            email: '',
            imageUrl: 'No Image',
          ), // Başlangıçta receiverUsername ile
          builder: (context, receiverSnapshot) {
            String receiverName = receiverUsername;
            String receiverImageUrl = 'No Image';
            if (receiverSnapshot.hasData) {
              receiverName = receiverSnapshot.data!.username;
              receiverImageUrl = receiverSnapshot.data!.imageUrl;
            } else if (receiverSnapshot.hasError) {
              log('Receiver stream hatası: ${receiverSnapshot.error}');
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (context) =>
                          ListenMessageBloc(chatRepository: context.read<ChatRepository>())
                            ..add(ListenMessagesRequested(chatId: chatId)),
                ),
                BlocProvider(
                  create:
                      (context) => SendMessageBloc(chatRepository: context.read<ChatRepository>()),
                ),
                BlocProvider(
                  create: (context) =>
                      TypingIndicatorBloc(context.read<ChatRepository>())
                        ..add(SubscribeTypingIndicator(receiverUid: receiverUid)),
                ),
              ],
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            receiverImageUrl.isNotEmpty && receiverImageUrl != 'No Image'
                                ? NetworkImage(
                                  '${receiverImageUrl}?ts=${DateTime.now().millisecondsSinceEpoch}',
                                )
                                : null,
                        backgroundColor: const Color.fromARGB(255, 62, 52, 52),
                        child:
                            receiverImageUrl.isEmpty || receiverImageUrl == 'No Image'
                                ? Icon(Icons.person, color: AppColors.white, size: 16)
                                : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        receiverName,
                        style: TextStyle(color: AppColors.white, fontSize: AppStyles.textLarge),
                      ),
                    ],
                  ),
                  backgroundColor: const Color.fromARGB(218, 170, 196, 172),
                  elevation: 0,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        log('Navigating to ProfilePageView for user: ${currentUser.uid}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePageView(user: currentUser),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              currentUser.imageUrl.isNotEmpty && currentUser.imageUrl != 'No Image'
                                  ? NetworkImage(
                                    '${currentUser.imageUrl}?ts=${DateTime.now().millisecondsSinceEpoch}',
                                  )
                                  : null,
                          backgroundColor: AppColors.grey,
                          child:
                              currentUser.imageUrl.isEmpty || currentUser.imageUrl == 'No Image'
                                  ? Icon(Icons.person, color: AppColors.white)
                                  : null,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'delete_chat') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text('Sohbeti sil'),
                                content: const Text(
                                  'Bu kişiyle olan tüm mesajlar silinecek. Emin misin?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop(false),
                                    child: const Text('İptal'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(dialogContext).pop(true),
                                    child: const Text('Sil'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            await context.read<ChatRepository>().deleteChat(chatId);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'delete_chat',
                          child: Text('Sohbeti sil'),
                        ),
                      ],
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    BlocBuilder<TypingIndicatorBloc, TypingIndicatorState>(
                      builder: (context, state) {
                        if (!state.isTyping) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$receiverName yazıyor...',
                              style: TextStyle(
                                color: AppColors.darkGrey.withOpacity(0.9),
                                fontSize: AppStyles.textSmall,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: MessageListWidget(
                        receiverUid: receiverUid,
                        chatId: chatId,
                      ),
                    ),
                    MessageInputWidget(receiverUid: receiverUid),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
