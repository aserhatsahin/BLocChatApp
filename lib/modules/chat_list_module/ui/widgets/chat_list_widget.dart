import 'dart:developer';

import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/commons/app_styles.dart';
import 'package:bloc_chatapp/modules/chat_list_module/bloc/chat_list/chat_list_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final User? currentUser = FirebaseAuth.instance.currentUser; // Null kontrolü için ? eklendi

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Center(child: Text("There is no user authenticated user"));
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
            log('NO CHATS');
            return const Center(child: Text("No Chats Yet"));
          }
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(0, AppStyles.paddingLarge, 0, AppStyles.paddingLarge),
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              final chat = state.chats[index];
              // ignore: unused_local_variable
              var displayUserId = 'No User';
              var displayUserName = 'No Name';

              final otherIndex = chat.participantIds.indexWhere((id) => id != currentUser!.uid);

              if (otherIndex != -1) {
                displayUserId = chat.participantIds[otherIndex];
                if (chat.participantNames.length > otherIndex) {
                  displayUserName = chat.participantNames[otherIndex];
                }
              }
              // context.read<ChatListBloc>().add(LoadChatsRequested(uid: displayUserId));
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  displayUserName,
                  style: TextStyle(fontSize: AppStyles.textLarge, color: AppColors.darkBackground),
                ),
                subtitle: Text(
                  chat.lastMessage.isEmpty ? "no msg yet " : chat.lastMessage,
                  style: TextStyle(fontSize: AppStyles.textLarge, color: AppColors.darkGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Uzun mesajlar için kesme
                ),
                tileColor: Colors.grey.shade200,

                // Opsiyonelö kaldırılabilir
                onTap: () {
                  // Sohbet ekranına yönlendirme
                },
              );
            },
          );
        } else if (state is ChatListLoadFail) {
          return const Center(child: Text("Couldn't load chats"));
        }
        return const SizedBox.shrink(); // Varsayılan durum (örneğin ChatListLoadInitial)
      },
    );
  }
}
