import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../widgets/liquid_glass_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? _selectedChatId;

  @override
  Widget build(BuildContext context) {
    if (_selectedChatId != null) {
      return ChatDetailScreen(
        title: _selectedChatId!,
        onBack: () => setState(() => _selectedChatId = null),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Messages", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildChatListItem(
            title: "Strategy Night",
            lastMsg: "Arjun: See you guys at 8!",
            time: "2m ago",
            unread: 2,
            icon: LucideIcons.swords,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 12),
          _buildChatListItem(
            title: "Weekend Hike",
            lastMsg: "Sara: I'll bring the water.",
            time: "1h ago",
            unread: 0,
            icon: LucideIcons.mountain,
            color: Colors.greenAccent,
          ),
          const SizedBox(height: 12),
          _buildChatListItem(
            title: "Coffee Catchup",
            lastMsg: "You: Where exactly is the cafe?",
            time: "Yesterday",
            unread: 0,
            icon: LucideIcons.coffee,
            color: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildChatListItem({
    required String title,
    required String lastMsg,
    required String time,
    required int unread,
    required IconData icon,
    required Color color,
  }) {
    return LiquidGlassCard(
      borderRadius: 16,
      child: ListTile(
        onTap: () => setState(() => _selectedChatId = title),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        subtitle: Text(
          lastMsg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            if (unread > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.socialOrange, shape: BoxShape.circle),
                child: Text(
                  unread.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const ChatDetailScreen({super.key, required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(LucideIcons.chevronLeft), onPressed: onBack),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text("Online", style: TextStyle(fontSize: 12, color: AppColors.safetyGreen)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ChatBubble(message: "Hey! Is the hangout still on?", sender: "Arjun", isMe: false),
                ChatBubble(message: "Yes! Everyone is coming.", sender: "Me", isMe: true),
                ChatBubble(message: "Great, see you there.", sender: "Arjun", isMe: false),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LiquidGlassCard(
        borderRadius: 24,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Write something...",
                    hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
                    border: InputBorder.none,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.trustBlue,
                child: IconButton(
                  icon: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String sender;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.trustBlue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2)),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : AppColors.textPrimary, fontSize: 14),
        ),
      ),
    );
  }
}
