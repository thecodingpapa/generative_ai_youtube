import 'package:flutter/material.dart';
import 'package:generative_ai_youtube/chatroom.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color.fromARGB(255, 0, 225, 255),
          brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(
          title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.red],
              tileMode: TileMode.mirror,
            ).createShader(bounds),
            child: const Text(
              'Gemini',
              style: TextStyle(
                // The color must be set to white for this to work
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        ),
        body: const Center(
          child: Chatroom(),
        ),
      ),
    );
  }
}
