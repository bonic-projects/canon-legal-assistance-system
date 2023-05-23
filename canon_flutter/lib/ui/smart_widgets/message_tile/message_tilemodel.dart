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

  // bool _isUnlocked = false;
  // bool get isUnlocked => _isUnlocked;
  // void unLock() async {
  //   setBusy(true);
  //   double? matchedFace = await _regulaService.checkMatch(_user.imgString!,
  //       isLiveness: _chatMessage.securityLevel == 2);
  //   if (matchedFace == null) {
  //     _bottomSheetService.showCustomSheet(
  //       variant: BottomSheetType.alert,
  //       title: "Canceled",
  //       description: "",
  //     );
  //   } else if (matchedFace > 90) {
  //     log.i("Unlocked: $matchedFace%");
  //     _isUnlocked = true;
  //     if (_chatMessage.fileLink != '') fileDownloadAndDecrypt();
  //     setBusy(false);
  //     _bottomSheetService.showCustomSheet(
  //       variant: BottomSheetType.success,
  //       title: "Face unlocked",
  //       description: "You can now view the file.",
  //     );
  //   } else {
  //     _bottomSheetService.showCustomSheet(
  //       variant: BottomSheetType.alert,
  //       title: "No verified",
  //       description: "User not verified or try again.",
  //     );
  //   }
  //   setBusy(false);
  // }

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
