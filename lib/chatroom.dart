import 'package:flutter/material.dart';
import 'package:generative_ai_youtube/message_widget.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({super.key});

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  List<String> chatbotHistory = [
    'Hi there!',
    'How can I assist you today?',
    'Sure, I can help with that!',
    'Here is the information you requested.',
    'Hi there!',
    'How can I assist you today?',
    'Sure, I can help with that!',
    'Here is the information you requested.',
    'Hi there!',
    'How can I assist you today?',
    'Sure, I can help with that!',
    'Here is the information you requested.',
  ];

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: ((context, index) {
              final content = chatbotHistory[index];

              return MessageWidget(
                message: content,
                isUserMessage: index%2 == 0,
              );
            }),
            itemCount: chatbotHistory.length,
            controller: _scrollController,
          ),
        ),
        if (isLoading) const LinearProgressIndicator(),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                onSubmitted: (value) {
                  if (!isLoading) {
                    _sendMessage(value);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type a message',
                ),
              ),
            ),
            IconButton(
              onPressed: isLoading? null:() {
                if (!isLoading) {
                  _sendMessage(_textController.text);
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCirc,
      );
    });
  }

  Future<void> _sendMessage(String value) async {
    if (value.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
      chatbotHistory.add(value);
      _textController.clear();
    });
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        chatbotHistory.add('I am a chatbot');
      });

      _scrollToBottom();
      _focusNode.requestFocus();
    });
  }
}
