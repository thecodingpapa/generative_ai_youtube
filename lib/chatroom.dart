import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:generative_ai_youtube/message_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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

  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  static const _apiKey = String.fromEnvironment('API_KEY');

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: "gemini-pro", apiKey: _apiKey);
    _chatSession = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: ((context, index) {
              final content = _chatSession.history.toList()[index];
              final text = content.parts
                  .whereType<TextPart>()
                  .map((part) => part.text)
                  .join();

              return MessageWidget(
                message: text,
                isUserMessage: content.role == 'user',
              );
            }),
            itemCount: _chatSession.history.length,
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
      _textController.clear();
    });
    _scrollToBottom();

    final response = await _chatSession.sendMessage(Content.text(value));


      setState(() {
        isLoading = false;
      });

    _scrollToBottom();
    _focusNode.requestFocus();


    // setState(() {
    //   isLoading = true;
    //   chatbotHistory.add(value);
    //   _textController.clear();
    // });
    // _scrollToBottom();

    // Future.delayed(const Duration(seconds: 1), () {
    //   setState(() {
    //     isLoading = false;
    //     chatbotHistory.add('I am a chatbot');
    //   });

    //   _scrollToBottom();
    //   _focusNode.requestFocus();
    // });
  }
}
