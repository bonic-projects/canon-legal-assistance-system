import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/chat.dart';
import '../../../models/chat_message.dart';
import '../../../services/firestore_service.dart';
import '../../../services/user_service.dart';

class ChatViewModel extends StreamViewModel<List<ChatMessage>>
    with FormStateHelper {
  final log = getLogger('ChatViewModel');

  // final _navigationService = locator<NavigationService>();
  // final _dialogService = locator<DialogService>();
  // final _bottomSheetService = locator<BottomSheetService>();
  final _userService = locator<UserService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  AppUser? get user => _userService.user;
  AppUser? _receiver;
  AppUser? get receiver => _receiver;

  final TextEditingController messageController = TextEditingController();

  final Chat chat;
  ChatViewModel({
    required this.chat,
  });

  void onModelReady() async {
    setBusy(true);
    final String rUid =
        chat.members.where((element) => element != user!.id).toList().first;
    _receiver = await _firestoreService.getUser(userId: rUid);
    if (_receiver != null) {
      log.i("Receiver: ${receiver!.fullName}");
    }
    setBusy(false);
  }

  AppUser getUser(String id) {
    if (id == user!.id) {
      return user!;
    } else {
      return _receiver!;
    }
  }

  @override
  Stream<List<ChatMessage>> get stream =>
      _firestoreService.getChatMessagesStream(chat.id);
}
