import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart'; // Ensure this is the correct import
import 'package:flutter/widgets.dart';
import '../consts.dart'; // Ensure this contains the Gemini_KEY
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    // Create a banner ad
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Ad loaded.'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    // Load the banner ad
    _bannerAd?.load();
  }

  @override
  void dispose() {
    // Dispose the ad to free up resources
    _bannerAd?.dispose();
    super.dispose();
  }










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
    return Scaffold(
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
      body: Stack(

        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/alhijrah.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          DashChat(
            typingUsers: isGeminiTyping ? [geminiUser] : [],
            inputOptions: const InputOptions(
              leading: [
                
              ],
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


          Center(
            child: _bannerAd == null
            ? const CircularProgressIndicator()
            : Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ),
        ],
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

      String responsePart = event.content?.parts?.map((part) => part.text).join('') ?? '';


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
