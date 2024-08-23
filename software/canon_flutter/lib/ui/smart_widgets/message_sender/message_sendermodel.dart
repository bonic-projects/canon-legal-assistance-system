import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/chat.dart';
import '../../../models/chat_message.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';
import '../../../services/user_service.dart';

class MessageSenderModel extends ReactiveViewModel {
  final log = getLogger('ChatViewModel');

  // final _navigationService = locator<NavigationService>();
  // final _dialogService = locator<DialogService>();
  // final _bottomSheetService = locator<BottomSheetService>();
  final _userService = locator<UserService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final StorageService _storageService = locator<StorageService>();

  AppUser? get user => _userService.user;

  final TextEditingController messageController = TextEditingController();

  final Chat chat;
  MessageSenderModel({
    required this.chat,
  });

  void onModelReady() async {
    addListenerController();
  }

  void addListenerController() {
    messageController.addListener(() {
      if (messageController.text.isNotEmpty || messageController.text.isEmpty) {
        notifyListeners();
      }
    });
  }

  double get progress => _storageService.progress;

  Future<void> sendMessage() async {
    setBusy(true);
    log.i("message");
    String messageId = await _firestoreService.getChatMessageId(chat);
    String? fileUrl;
    if (_fileSelected != null) {
      fileUrl = await _storageService.uploadFile(
          _fileSelected!, "chats/${chat.id}/$messageId");
      notifyListeners();
    }
    final newMessage = ChatMessage(
      message: messageController.text.isNotEmpty
          ? messageController.text
          : 'File: ${_fileSelected!.path.split(".").last}',
      senderId: user!.id,
      timestamp: DateTime.now(),
      fileLink: fileUrl ?? '',
      fileFormat: fileUrl != null ? _fileSelected!.path.split(".").last : '',
      id: messageId,
    );
    messageController.clear();
    if (_fileSelected != null) _fileSelected = null;
    await _firestoreService.addChatMessage(chat, newMessage, id: newMessage.id);
    setBusy(false);
  }

  File? _fileSelected;
  File? get fileSelected => _fileSelected;
  Future filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      _fileSelected = File(result.files.single.path!);
      log.i(result.files.single.path);
      notifyListeners();
    } else {
      log.i("File picker error");
    }
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_storageService];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
