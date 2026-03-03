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
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: AppStyles.heightXLarge * 1.5,
                    color: AppColors.darkGrey.withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Henüz sohbet yok",
                    style: TextStyle(
                      fontSize: AppStyles.textLarge,
                      color: AppColors.darkBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Üstteki arama çubuğundan bir kullanıcı bulup\nilk sohbetini başlatabilirsin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppStyles.textMedium,
                      color: AppColors.darkGrey.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            );
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

                    final lastMessageTimeText =
                        TimeOfDay.fromDateTime(chat.lastMessageTime).format(context);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        leading: CircleAvatar(
                          radius: 22,
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: subtitleWidget,
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              lastMessageTimeText,
                              style: TextStyle(
                                fontSize: AppStyles.textSmall,
                                color: AppColors.darkGrey.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: AppColors.darkGrey.withOpacity(0.8),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MultiRepositoryProvider(
                                    providers: [
                                      RepositoryProvider<UserRepository>.value(
                                        value: userRepository,
                                      ),
                                      RepositoryProvider<ChatRepository>.value(
                                        value: chatRepository,
                                      ),
                                    ],
                                    child: ChatPageView(
                                      receiverUid: displayUserId,
                                      receiverUsername: displayUserName,
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
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
