import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/device_identity_provider.dart';
import '../../home/providers/home_provider.dart';
import '../providers/group_chat_provider.dart';
import '../widgets/group_message_bubble.dart';

class GroupChatScreen extends ConsumerStatefulWidget {
  final String journeyId;

  const GroupChatScreen({super.key, required this.journeyId});

  @override
  ConsumerState<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends ConsumerState<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(ensureGroupChatMemberAuthProvider(widget.journeyId)),
    );
  }

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

  Future<void> _sendMessage() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    await ref
        .read(groupChatNotifierProvider(widget.journeyId).notifier)
        .sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync =
        ref.watch(groupChatMessagesProvider(widget.journeyId));
    final isReady = ref.watch(groupChatReadyProvider(widget.journeyId));
    final isMember = ref.watch(isJourneyMemberProvider(widget.journeyId));
    final currentDeviceId = ref.watch(deviceIdProvider);

    ref.listen(groupChatMessagesProvider(widget.journeyId), (_, next) {
      if (next.hasValue) _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: AppColors.bg0,
      appBar: AppBar(
        backgroundColor: AppColors.bg1,
        elevation: 0,
        title: Text(
          'Convoy Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: !isMember
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Text(
                  'Join this tour to view convoy chat.',
                  style: TextStyle(
                    color: AppColors.convoyNeutral,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Text(
                        'No messages yet — say hi to the convoy!',
                        style: TextStyle(
                          color: AppColors.convoyNeutral,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return GroupMessageBubble(
                      message: message,
                      isMine: message.senderDeviceId == currentDeviceId,
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.convoyBlue),
              ),
              error: (err, _) => Center(
                child: Text(
                  'Failed to load chat: $err',
                  style: const TextStyle(color: AppColors.convoyRed),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
              decoration: BoxDecoration(
                color: AppColors.bg1,
                border: Border(
                  top: BorderSide(
                    color: AppColors.border.withOpacity(0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: isReady,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: isReady
                            ? 'Message the convoy...'
                            : 'Loading tour chat...',
                        hintStyle:
                            TextStyle(color: Colors.white30, fontSize: 13.sp),
                        filled: true,
                        fillColor: AppColors.bg2,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: isReady ? _sendMessage : null,
                    icon: const Icon(Icons.send, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.convoyBlue,
                      disabledBackgroundColor: AppColors.bg2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
