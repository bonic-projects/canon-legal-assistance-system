import 'dart:io';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/chat.dart';
import '../../../models/chat_message.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';

class MessageTileModel extends BaseViewModel {
  final log = getLogger('MessageTileModel');

  final _bottomSheetService = locator<BottomSheetService>();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  late Chat _chat;
  late AppUser _user;
  late ChatMessage _chatMessage;
  void onModelReady(Chat chat, ChatMessage chatMessage, AppUser user) async {
    _chat = chat;
    _user = user;
    _chatMessage = chatMessage;
    if (_chatMessage.fileLink != '') fileDownloadAndDecrypt();
    notifyListeners();
  }

  Future<void> deleteMessage() async {
    log.i("Delete message");
    setBusy(true);
    if (_chatMessage.fileLink != '') {
      await _storageService.deleteFile("chats/${_chat.id}/${_chatMessage.id}");
    }
    await _firestoreService.deleteChatMessage(_chat.id, _chatMessage.id);
    setBusy(false);
  }

  File? _file;
  File? get file => _file;
  void fileDownloadAndDecrypt() async {
    log.i("Started");
    File? downloaded = await _storageService.downloadFile(_chatMessage.fileLink,
        'chats/${_chat.id}/${_chatMessage.id}', _chatMessage.fileFormat);
    if (downloaded != null) {
      _file = downloaded;
      // downloaded.delete();
      notifyListeners();
    }
  }
}
