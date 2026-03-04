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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isMe ? AppColors.chatApp : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(6),
                bottomRight: isMe ? const Radius.circular(6) : const Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    color: isMe ? Colors.white : AppColors.darkBackground,
                    fontSize: AppStyles.textLarge,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      TimeOfDay.fromDateTime(message.sendedAt).format(context),
                      style: TextStyle(
                        color: isMe
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.darkGrey.withOpacity(0.8),
                        fontSize: AppStyles.textSmall,
                      ),
                    ),
                    if (message.isEdited) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(düzenlendi)',
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.darkGrey.withOpacity(0.7),
                          fontSize: AppStyles.textSmall,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
