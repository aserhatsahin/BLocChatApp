import 'dart:developer';
import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/data/models/user_model.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:bloc_chatapp/data/repositories/user_repository.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/chat_list/chat_list_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/ui/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListWidget extends StatelessWidget {
  final UserModel user;
  final UserRepository userRepository;
  final ChatRepository chatRepository;

  const ChatListWidget({
    super.key,
    required this.user,
    required this.userRepository,
    required this.chatRepository,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String? currentUid = currentUser?.uid;
    if (currentUser == null) {
      return const Center(child: Text("Yetkili Kullanıcı Yok"));
    }

    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        log("📲 UI State: ${state.runtimeType}");
        if (state is ChatListLoading) {
          return Container(
            padding: const EdgeInsets.all(AppStyles.paddingSmall),
            constraints: const BoxConstraints(maxHeight: AppStyles.heightXLarge * 4),
            child: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
          );
        } else if (state is ChatListLoaded) {
          if (state.chats.isEmpty) {
            log('SOHBET YOK');
            return const Center(child: Text("Henüz Sohbet Yok"));
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(
              0,
              AppStyles.paddingLarge,
              0,
              AppStyles.paddingLarge,
            ),
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              var displayUserId = 'Kullanıcı Yok';
              var displayUserName = 'İsim Yok';

              final otherIndex = chat.participantIds.indexWhere((id) => id != currentUid);

              if (otherIndex != -1) {
                displayUserId = chat.participantIds[otherIndex];
                if (chat.participantNames.length > otherIndex) {
                  displayUserName = chat.participantNames[otherIndex];
                }

                return FutureBuilder<UserModel>(
                  future: userRepository.getUserData(displayUserId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.grey,
                          child: Icon(Icons.person, color: AppColors.white),
                        ),
                        title: Text(displayUserName),
                        subtitle: const Text('Yükleniyor...'),
                      );
                    }

                    final otherUser = snapshot.data!;
                    final displayImageUrl = otherUser.imageUrl;
                    displayUserName = otherUser.username;

                    Widget subtitleWidget;
                    if (chat.lastMessage.isEmpty) {
                      subtitleWidget = Text(
                        "Henüz mesaj yok",
                        style: TextStyle(fontSize: AppStyles.textLarge, color: AppColors.darkGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else if (chat.lastMessageSenderId == currentUid) {
                      subtitleWidget = Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "✓✓ ",
                            style: TextStyle(
                              fontSize: AppStyles.textSmall,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              chat.lastMessage,
                              style: TextStyle(
                                fontSize: AppStyles.textLarge,
                                color: AppColors.darkGrey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    } else {
                      subtitleWidget = Text(
                        "$displayUserName: ${chat.lastMessage}",
                        style: TextStyle(fontSize: AppStyles.textLarge, color: AppColors.darkGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            displayImageUrl.isNotEmpty && displayImageUrl != 'No Image'
                                ? NetworkImage(
                                  '${displayImageUrl}?ts=${DateTime.now().millisecondsSinceEpoch}',
                                )
                                : null,
                        backgroundColor: AppColors.grey,
                        child:
                            displayImageUrl.isEmpty || displayImageUrl == 'No Image'
                                ? const Icon(Icons.person, color: AppColors.white)
                                : null,
                      ),
                      title: Text(
                        displayUserName,
                        style: TextStyle(
                          fontSize: AppStyles.textLarge,
                          color: AppColors.darkBackground,
                        ),
                      ),
                      subtitle: subtitleWidget,
                      tileColor: Colors.grey.shade200,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MultiRepositoryProvider(
                                  providers: [
                                    RepositoryProvider<UserRepository>.value(value: userRepository),
                                    RepositoryProvider<ChatRepository>.value(value: chatRepository),
                                  ],
                                  child: ChatPageView(
                                    receiverUid: displayUserId,
                                    receiverUsername: displayUserName,
                                  ),
                                ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        } else if (state is ChatListLoadFail) {
          return const Center(child: Text("Sohbetler yüklenemedi"));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
