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
    if (!ref.read(chatbotReadyProvider(widget.journeyId))) return;
    _controller.clear();
    _scrollToBottom();
    await ref
        .read(chatbotMessagesNotifierProvider(widget.journeyId).notifier)
        .sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync =
        ref.watch(chatbotMessagesNotifierProvider(widget.journeyId));
    final isReady = ref.watch(chatbotReadyProvider(widget.journeyId));
    final isIndexing = ref.watch(chatbotPoisLoadingProvider(widget.journeyId));
    final indexingFailed =
        ref.watch(chatbotIndexingFailedProvider(widget.journeyId));

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
        toolbarHeight: 56.h,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Route Co-Pilot\n',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: 'AI Road Trip Tour Guide',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.convoyGreen,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep,
                color: AppColors.convoyRed, size: 22.sp),
            tooltip: 'Clear History',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.bg2,
                  title: const Text('Clear Chat History?',
                      style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'This will erase all previous messages with the guide for this journey.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white38)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.convoyRed),
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        ref
                            .read(chatbotMessagesNotifierProvider(
                                    widget.journeyId)
                                .notifier)
                            .clearHistory();
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
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: !isReady
                  ? _buildIndexingState(isIndexing, indexingFailed)
                  : messagesAsync.when(
                      data: (messages) {
                        if (messages.isEmpty) {
                          return _buildEmptyState();
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          itemCount: messages.length,
                          itemBuilder: (context, index) =>
                              ChatBubble(message: messages[index]),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.convoyBlue),
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
          ),
          if (isReady) _buildSuggestionsBar(),
          SafeArea(
            top: false,
            child: isReady
                ? _buildInputBar()
                : _buildDisabledInputBar(isIndexing, indexingFailed),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexingState(bool isIndexing, bool indexingFailed) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isIndexing)
              const CircularProgressIndicator(color: AppColors.convoyBlue)
            else
              Icon(Icons.cloud_off, size: 48.sp, color: AppColors.convoyAmber),
            SizedBox(height: 20.h),
            Text(
              isIndexing
                  ? 'Indexing places along your route...'
                  : indexingFailed
                      ? 'Could not load route places'
                      : 'Preparing your route guide...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              isIndexing
                  ? 'We are fetching restaurants, fuel stops, and scenic spots from OpenStreetMap. This usually takes under a minute.'
                  : indexingFailed
                      ? 'Check your internet connection and tap Retry below.'
                      : 'Please wait while route data is prepared.',
              style: TextStyle(
                color: AppColors.convoyNeutral,
                fontSize: 12.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (indexingFailed) ...[
              SizedBox(height: 20.h),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(retryRoutePoiIndexingProvider(widget.journeyId)),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Retry indexing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.convoyBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledInputBar(bool isIndexing, bool indexingFailed) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        border: Border(
          top: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
        ),
      ),
      child: Text(
        isIndexing
            ? 'Chat will unlock once route places are indexed.'
            : indexingFailed
                ? 'Indexing failed. Retry to unlock the tour guide.'
                : 'Waiting for route places...',
        style: TextStyle(color: Colors.white38, fontSize: 12.sp),
        textAlign: TextAlign.center,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
      child: Row(
        children: _suggestions.map((suggestion) {
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ActionChip(
              backgroundColor: AppColors.bg1,
              side: BorderSide(color: AppColors.border.withOpacity(0.5)),
              visualDensity: VisualDensity.compact,
              label: Text(
                suggestion,
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
              onPressed: () => _sendMessage(suggestion),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              icon: const Icon(Icons.send, color: Colors.white, size: 22),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
