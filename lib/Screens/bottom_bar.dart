import 'package:aiinalhijrah/Widgets/chat_history.dart';
import 'package:aiinalhijrah/Widgets/chat_profile.dart';
import 'package:aiinalhijrah/Widgets/chat_widget.dart';
import 'package:flutter/material.dart';
// Ensure this is the correct import
import 'package:flutter/widgets.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// Ensure this contains the Gemini_KEY

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  Widget current_Widget = const DashChatitle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.chat),
              title: const Text("Home"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.history),
              title: const Text("History"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.pink,
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              setState(() {
                current_Widget = const DashChatitle();
              });
            } else if (index == 1) {
              setState(() {
                current_Widget = const ChatHistory();
              });
            } else if (index == 2) {
              setState(() {
                current_Widget = const ChatProfile();
              });
            }            
          }),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu press
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 50,
            ),
            const SizedBox(width: 10),
            const Text(
              'AI in AH',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
            ),
          ],
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/logo.png'),
          ),
        ],
      ),
      body: current_Widget,
    );
  }
}
