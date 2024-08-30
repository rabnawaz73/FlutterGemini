import 'package:flutter/material.dart';

class ChatProfile extends StatefulWidget {
  const ChatProfile({super.key});

  @override
  State<ChatProfile> createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(child: Text('Chat Profile'),),
    );
  }
}