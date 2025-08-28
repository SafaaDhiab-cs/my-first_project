import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final List<Map<String, String>> messages = []; // قائمة لتخزين الرسائل
  final TextEditingController _controller = TextEditingController();

  // دالة لإرسال الرسائل
  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "message": message}); // رسالة المستخدم
    });

    _controller.clear();

    // محاكاة رد الذكاء الاصطناعي
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.add({"sender": "bot", "message": _getBotResponse(message)});
      });
    });
  }

  // الردود المحاكية
  String _getBotResponse(String userMessage) {
    if (userMessage.contains("مرحبا")) {
      return "مرحبًا! كيف يمكنني مساعدتك اليوم؟";
    } else if (userMessage.contains("تسجيل")) {
      return "يمكنك التسجيل عبر موقعنا الإلكتروني أو التواصل معنا.";
    } else if (userMessage.contains("شكرا")) {
      return "على الرحب والسعة! 😊";
    } else {
      return "عذرًا، لم أفهم ذلك. هل يمكنك إعادة صياغته؟";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'الدردشة'),
      ),
      body: Column(
        children: [
          _buildChatList(), // قائمة الرسائل
          _buildMessageInput(), // إدخال الرسائل
        ],
      ),
    );
  }

  // ويدجت لعرض قائمة الرسائل
  Widget _buildChatList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final isUser = messages[index]["sender"] == "user";
          return ChatBubble(
            isUser: isUser,
            message: messages[index]["message"]!,
          );
        },
      ),
    );
  }

  // ويدجت لإدخال الرسائل
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "اكتب سؤالك...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              _sendMessage(_controller.text);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String message;

  const ChatBubble({required this.isUser, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF196098) : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 20 : 0),
            topRight: Radius.circular(isUser ? 0 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
            fontFamily: 'Arial', // يمكنك استخدام خط يدعم العربية
          ),
          textAlign: TextAlign.right, // محاذاة النص إلى اليمين
        ),
      ),
    );
  }
}
