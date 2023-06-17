import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/firestore_service.dart';
import '../../../services/gpt_service.dart';
import '../../../services/user_service.dart';

class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage({required this.content, required this.isUser});
}

class GptViewModel extends BaseViewModel {
  final log = getLogger('ChatViewModel');

  // final _userService = locator<UserService>();
  // final _firestoreService = locator<FirestoreService>();
  // final _dialogService = locator<DialogService>();
  final _gptService = locator<GptChatService>();

  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();

  void onModelReady() async {
    final responseContent = await generateResponse();
    addMessage(responseContent, false);
  }

  void addMessage(String content, bool isUser) {
    final message = ChatMessage(content: content, isUser: isUser);
    messages.add(message);
    notifyListeners();
  }

  void sendMessage() async {
    final messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty) {
      addMessage(messageContent, true);
      messageController.clear();
      // Simulate response delay
      // Generate a response message
      final responseContent = await generateResponse();
      addMessage(responseContent, false);
      log.e(messages.length);
      if (messages.length == 2) {
        addMessage("Paste the document needed to summarise below >", true);
      }
    }
  }

  Future<String> generateResponse() async {
    setBusy(true);
    // String res = await _gptService.getGptReply(messages.last.content);
    String aiMsg = await generateChat(
        msg: messages.isNotEmpty ? messages.last.content : null);
    setBusy(false);
    return aiMsg;
  }

  Future<String> generateChat({String? msg}) {
    return _gptService.getGptReply(text: msg, isSum: true);
  }
}
