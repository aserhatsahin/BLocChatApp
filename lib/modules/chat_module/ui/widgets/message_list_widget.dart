import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_event.dart';
import 'package:bloc_chatapp/modules/chat_module/ui/widgets/message_bubble_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageListWidget extends StatelessWidget {
  final String receiverUid;
  final String chatId; // chatId’yi parametre olarak ekliyoruz

  const MessageListWidget({super.key, required this.receiverUid, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListenMessageBloc, ListenMessageState>(
      builder: (context, state) {
        if (state is ListenMessageLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ListenMessageSuccess) {
          final messages = state.messages;
          if (messages.isEmpty) {
            return const Center(child: Text('Henüz mesaj yok.'));
          }
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isMe = message.senderId != receiverUid;
              return MessageBubbleWidget(
                message: message,
                isMe: isMe, // isMe parametresini ekliyoruz
              );
            },
          );
        } else if (state is ListenMessageFailure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.error),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // chatId’yi parametre olarak aldığımız için tekrar oluşturmaya gerek yok
                    context.read<ListenMessageBloc>().add(ListenMessagesRequested(chatId: chatId));
                  },
                  child: const Text('Yeniden Dene'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
