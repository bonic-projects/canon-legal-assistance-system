import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/chat.dart';
import '../../../services/firestore_service.dart';
import '../../../services/user_service.dart';

class NoticeSheetModel extends BaseViewModel {
  final log = getLogger('NoticeSheetModel');

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final _userService = locator<UserService>();

  List<AppUser> _users = [];
  List<AppUser> get users => _users;

  final TextEditingController messageController = TextEditingController();

  Future<void> searchUsers(String keyword) async {
    if (keyword.isNotEmpty) {
      setBusy(true);
      log.i("getting users");
      try {
        _users = await _firestoreService.searchUsers(keyword);
        log.i(_users.length);
        _users = _users
            .where((element) => element.id != _userService.user!.id)
            .toList();
        setError(null);
      } catch (e) {
        setError(e.toString());
      }

      setBusy(false);
    }
  }

  AppUser? _user;
  AppUser? get user => _user;

  void setUser(AppUser user) {
    _user = user;
    messageController.clear();
    notifyListeners();
  }

  String _chatName = '';
  String get chatName => _chatName;

  void setChatName(String value) {
    _chatName = value;
    notifyListeners();
  }

  Future<Chat> createChat() async {
    final chatName = _chatName.isNotEmpty ? _chatName : user!.fullName;
    final chat = Chat.create(chatName, [_userService.user!.id, user!.id]);
    final chatCreated = await _firestoreService.createChat(chat);
    // await _navigationService.back();
    return chatCreated;
  }
}
