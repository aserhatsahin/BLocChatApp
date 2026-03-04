import 'dart:ui';

import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/listen_message/listen_message_event.dart';
import 'package:bloc_chatapp/modules/chat_module/ui/widgets/message_bubble_widget.dart';
import 'package:bloc_chatapp/data/repositories/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageListWidget extends StatelessWidget {
  final String receiverUid;
  final String chatId; // chatId’yi parametre olarak ekliyoruz

  const MessageListWidget({super.key, required this.receiverUid, required this.chatId});

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

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

          final currentUser = FirebaseAuth.instance.currentUser;
          final currentUid = currentUser?.uid;

          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isMe = currentUid != null && message.senderId == currentUid;

              bool showDateHeader = false;
              if (index == messages.length - 1) {
                showDateHeader = true;
              } else {
                final nextMessage = messages[index + 1];
                if (!_isSameDay(message.sendedAt, nextMessage.sendedAt)) {
                  showDateHeader = true;
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showDateHeader)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _formatDate(message.sendedAt),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onLongPressStart: isMe
                        ? (details) async {
                            final tapPosition = details.globalPosition;

                            final action = await showDialog<String>(
                              context: context,
                              barrierColor: Colors.black.withOpacity(0.1),
                              builder: (dialogContext) {
                                return Stack(
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8,
                                        sigmaY: 8,
                                      ),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.05),
                                      ),
                                    ),
                                    Positioned(
                                      left: tapPosition.dx - 140,
                                      top: tapPosition.dy - 80,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          width: 280,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                dense: true,
                                                leading:
                                                    const Icon(Icons.edit, size: 20),
                                                title: const Text(
                                                  'Mesajı düzenle',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                onTap: () => Navigator.of(
                                                  dialogContext,
                                                ).pop('edit'),
                                              ),
                                              ListTile(
                                                dense: true,
                                                leading:
                                                    const Icon(Icons.delete_outline, size: 20),
                                                title: const Text(
                                                  'Mesajı sil',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                onTap: () => Navigator.of(
                                                  dialogContext,
                                                ).pop('delete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (action == 'delete') {
                              final chatRepository =
                                  context.read<ChatRepository>();
                              await chatRepository.deleteMessage(
                                chatId: chatId,
                                messageId: message.messageId,
                              );
                            } else if (action == 'edit') {
                              final controller = TextEditingController(
                                text: message.message,
                              );
                              final newText =
                                  await showDialog<String>(context: context, builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text('Mesajı düzenle'),
                                  content: TextField(
                                    controller: controller,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Yeni mesajı yaz...',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: const Text('İptal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext)
                                            .pop(controller.text.trim());
                                      },
                                      child: const Text('Kaydet'),
                                    ),
                                  ],
                                );
                              });

                              if (newText != null &&
                                  newText.isNotEmpty &&
                                  newText != message.message) {
                                final chatRepository =
                                    context.read<ChatRepository>();
                                await chatRepository.editMessage(
                                  chatId: chatId,
                                  messageId: message.messageId,
                                  newText: newText,
                                );
                              }
                            }
                          }
                        : null,
                    child: MessageBubbleWidget(
                      message: message,
                      isMe: isMe,
                    ),
                  ),
                ],
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
