import 'package:flutter/material.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Chat History'),),
    );
  }
}