import 'package:bloc_chatapp/commons/export_commons.dart';
import 'package:bloc_chatapp/data/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubbleWidget({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isMe ? AppColors.lightGreen : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: AppStyles.textLarge,
            ),
          ),
        ),
      ),
    );
  }
}
