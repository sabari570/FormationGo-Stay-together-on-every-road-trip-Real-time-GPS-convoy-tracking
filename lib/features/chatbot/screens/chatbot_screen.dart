import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/chatbot_provider.dart';
import '../widgets/chat_bubble.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  final String journeyId;

  const ChatbotScreen({super.key, required this.journeyId});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _suggestions = [
    'Where can we eat?',
    'Best rest stops nearby?',
    'Any scenic spots?',
    'Where is the closest petrol bunk?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();
    _scrollToBottom();
    await ref.read(chatbotMessagesNotifierProvider(widget.journeyId).notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatbotMessagesNotifierProvider(widget.journeyId));

    // Scroll to bottom when list is loaded or updated
    ref.listen(chatbotMessagesNotifierProvider(widget.journeyId), (prev, next) {
      if (next.hasValue) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg1,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route Co-Pilot',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'AI Road Trip Tour Guide',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.convoyGreen,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, color: AppColors.convoyRed, size: 22.sp),
            tooltip: 'Clear History',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.bg2,
                  title: const Text('Clear Chat History?', style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'This will erase all previous messages with the guide for this journey.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel', style: TextStyle(color: Colors.white38)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.convoyRed),
                      child: const Text('Clear', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        ref.read(chatbotMessagesNotifierProvider(widget.journeyId).notifier).clearHistory();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Message List
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => ChatBubble(message: messages[index]),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.convoyBlue),
                  ),
                ),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      'Failed to load conversation: $err',
                      style: const TextStyle(color: AppColors.convoyRed),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            // Suggestions List
            _buildSuggestionsBar(),

            // Chat Input Bar
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.convoyGreen.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assistant,
                size: 48.sp,
                color: AppColors.convoyGreen,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Your Journey Guide is Ready!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ask me about restaurants, nature parks, scenic views, fuel stations, or rest areas along our route.',
              style: TextStyle(
                color: AppColors.convoyNeutral,
                fontSize: 12.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsBar() {
    return Container(
      height: 36.h,
      margin: EdgeInsets.only(bottom: 6.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ActionChip(
              backgroundColor: AppColors.bg1,
              side: BorderSide(color: AppColors.border.withOpacity(0.5)),
              label: Text(
                suggestion,
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
              onPressed: () => _sendMessage(suggestion),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        border: Border(
          top: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bg2,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.border.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your question...',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 13.sp),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  border: InputBorder.none,
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.convoyBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
