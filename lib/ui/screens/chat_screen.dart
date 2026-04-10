import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1B1F) : const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "AI Chat",
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1C1B1F), fontSize: 16),
        ),
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: chatProvider.useOpenAI,
              onChanged: (val) => chatProvider.toggleApi(val),
              activeColor: const Color(0xFFEADDFF),
              activeTrackColor: const Color(0xFF6750A4),
            ),
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark ? Colors.white : const Color(0xFF1C1B1F),
              size: 20,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: isDark ? Colors.white : const Color(0xFF1C1B1F),
              size: 20,
            ),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.messages.isEmpty
                ? Center(
                    child: Opacity(
                      opacity: isDark ? 0.7 : 1.0,
                      child: Image.network(
                        "https://img.freepik.com/free-vector/flat-customer-support-illustration_23-2148899114.jpg",
                        width: 250,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.chat_bubble_outline, size: 100, color: isDark ? Colors.grey[800] : const Color(0xFFEADDFF)),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final msg = chatProvider.messages[index];
                      return MessageBubble(
                        text: msg['text'],
                        isUser: msg['role'] == 'user',
                        time: msg['time'],
                      );
                    },
                  ),
          ),
          if (chatProvider.isTyping)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text("...", style: TextStyle(color: Color(0xFFD0BCFF), fontWeight: FontWeight.bold)),
            ),
          _buildInputArea(chatProvider, isDark),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isDark ? const Color(0xFF1C1B1F) : const Color(0xFFFBF8FF),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "Type message...",
                  hintStyle: TextStyle(color: isDark ? Colors.grey : const Color(0xFF49454F), fontSize: 14),
                  border: InputBorder.none,
                ),
                onSubmitted: (val) => _send(provider),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: isDark ? Colors.white : const Color(0xFF1C1B1F), size: 20),
              onPressed: () => _send(provider),
            ),
          ],
        ),
      ),
    );
  }

  void _send(ChatProvider provider) {
    if (_controller.text.trim().isNotEmpty) {
      provider.sendMessage(_controller.text.trim());
      _controller.clear();
      _scrollToBottom();
    }
  }
}
