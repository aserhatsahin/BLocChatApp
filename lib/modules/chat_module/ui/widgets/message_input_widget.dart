import 'package:bloc_chatapp/commons/app_colors.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/send_message/send_message_bloc.dart';
import 'package:bloc_chatapp/modules/chat_module/bloc/send_message/send_message_event.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageInputWidget extends StatefulWidget {
  final String receiverUid;

  const MessageInputWidget({super.key, required this.receiverUid});

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _isTextNotEmpty = ValueNotifier<bool>(false);
  bool _showEmojiPicker = false;

  @override
  void dispose() {
    _controller.dispose();
    _isTextNotEmpty.dispose();
    super.dispose();
  }

  void _onEmojiSelected(Emoji emoji) {
    _controller.text += emoji.emoji;
    _isTextNotEmpty.value = _controller.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendMessageBloc, SendMessageState>(
      listener: (context, state) {
        if (state is SendMessageSuccess) {
          _controller.clear();
          _isTextNotEmpty.value = false;
        } else if (state is SendMessageFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                      if (_showEmojiPicker) {
                        FocusScope.of(context).unfocus();
                      }
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        _isTextNotEmpty.value = value.trim().isNotEmpty;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Mesaj yaz...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: _isTextNotEmpty,
                  builder: (context, value, child) {
                    return CircleAvatar(
                      backgroundColor:
                          value ? AppColors.primary : Color.fromARGB(218, 170, 196, 172),
                      child: IconButton(
                        icon: const Icon(Icons.send_outlined, color: Colors.white),
                        onPressed:
                            value
                                ? () {
                                  final message = _controller.text.trim();
                                  context.read<SendMessageBloc>().add(
                                    SendMessageRequested(
                                      message: message,
                                      receiverUid:
                                          widget.receiverUid, // receiverUID yerine receiverUid
                                    ),
                                  );
                                }
                                : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: 256,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _onEmojiSelected(emoji);
                },
                config: const Config(
                  height: 256,
                  checkPlatformCompatibility: true,
                  emojiTextStyle: TextStyle(fontSize: 32),
                  viewOrderConfig: ViewOrderConfig(),
                  emojiViewConfig: EmojiViewConfig(
                    backgroundColor: Colors.white,
                    columns: 7,
                    emojiSizeMax: 32,
                  ),
                  skinToneConfig: SkinToneConfig(enabled: true),
                  categoryViewConfig: CategoryViewConfig(
                    recentTabBehavior: RecentTabBehavior.RECENT,
                    tabIndicatorAnimDuration: Duration(milliseconds: 300),
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(enabled: true),
                  searchViewConfig: SearchViewConfig(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
