import 'package:aiinalhijrah/consts.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class DashChatitle extends StatefulWidget {
  const DashChatitle({super.key});

  @override
  State<DashChatitle> createState() => _DashChatitleState();
}

class _DashChatitleState extends State<DashChatitle> {
  
  final ChatUser geminiUser = ChatUser(
    id: '2',
    firstName: 'Gemini',
  );
  final ChatUser currentUser = ChatUser(
    id: '1',
    firstName: 'AL-Hjrah',
    lastName: 'Rabnawaz',
    profileImage: 'assets/logo.png',
  );
  bool isGeminiTyping = false;
  List<ChatMessage> chatMessages = <ChatMessage>[];
  final Gemini gemini = Gemini.init(apiKey: Gemini_KEY);

  String completeResponse = '';
  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: DashChatitle(), // Use the DashChatitle widget here
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              width: Size.width * 0.8,
              height: Size.height * 0.8,
              'assets/alhijrah.jpg',
              fit: BoxFit.cover,
            ),
            Container(
              width: Size.width * 0.8,
              height: Size.height * 0.8,
              color: Colors.black.withOpacity(0.5),
            ),
            SizedBox(
              width: Size.width * 0.8,
              height: Size.height * 0.8,
              child: DashChat(
                typingUsers: isGeminiTyping ? [geminiUser] : [],
                inputOptions: const InputOptions(
                  leading: [],
                  autocorrect: true,
                  cursorStyle: CursorStyle(
                    color: Colors.black,
                  ),
                  sendOnEnter: true,
                ),
                currentUser: currentUser,
                messageOptions: const MessageOptions(
                  currentUserContainerColor: Colors.blueAccent,
                ),
                onSend: _handleSend,
                messages: chatMessages,
              ),
            ),
           ],
        ),
      ),
    );
  }

  void _handleSend(ChatMessage message) {
    setState(() {
      chatMessages.insert(0, message);
      isGeminiTyping = true;
    });
    getChats(message);
  }

  Future<void> getChats(ChatMessage message) async {
    completeResponse = '';

    try {
      // Await for the stream to emit events
      await for (var event in gemini.streamGenerateContent(message.text)) {
        String responsePart =
            event.content?.parts?.map((part) => part.text).join('') ?? '';

        if (responsePart.isNotEmpty) {
          completeResponse += responsePart;
        }
      }

      setState(() {
        isGeminiTyping = false;
        chatMessages.insert(
          0,
          ChatMessage(
            replyTo: message,
            user: geminiUser,
            createdAt: DateTime.now(),
            text: completeResponse,
          ),
        );
      });
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        isGeminiTyping = false;
      });
    }
  }
}
