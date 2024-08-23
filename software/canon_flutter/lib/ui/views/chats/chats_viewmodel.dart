import 'package:canon/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/chat.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';
import '../../../services/user_service.dart';
import '../../common/app_strings.dart';

class ChatsViewModel extends StreamViewModel<List<Chat>> {
  final log = getLogger('HomeViewModel');

  final _navigationService = locator<NavigationService>();
  // final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _userService = locator<UserService>();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  AppUser? get user => _userService.user;

  void showBottomSheetUserSearch() async {
    final result = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
    if (result != null) {
      if (result.confirmed) log.i("Chat created: ${result.data.name}");
    }
  }

  bool _isChatDeleting = false;
  bool get isChatDeleting => _isChatDeleting;
  void deleteChat(Chat chat) async {
    _isChatDeleting = true;
    notifyListeners();
    await _storageService.deleteChatFiles(chat.id);
    await _firestoreService.deleteChat(chat);
    _isChatDeleting = false;
    notifyListeners();
  }

  ///===========================
  @override
  Stream<List<Chat>> get stream => _firestoreService.getChats();

  Future<void> navigateToChat(Chat chat) async {
    if (!_isChatDeleting) _navigationService.navigateToChatView(chat: chat);
  }
}
