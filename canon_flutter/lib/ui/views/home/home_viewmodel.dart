import 'package:canon/app/app.dialogs.dart';
import 'package:canon/app/app.locator.dart';
import 'package:canon/app/app.logger.dart';
import 'package:canon/app/app.router.dart';
import 'package:canon/models/appuser.dart';
import 'package:canon/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  // final _bottomSheetService = locator<BottomSheetService>();

  final _userService = locator<UserService>();
  bool get hasUser => _userService.hasLoggedInUser;

  AppUser? get user => _userService.user;

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // await Future.delayed(const Duration(seconds: 1));
    if (hasUser) {
      setBusy(true);
      AppUser? _user = await _userService.fetchUser();
      if (_user != null) {
        log.i(_user.fullName);
        // if (_user.userRole == 'patient') openUserView();
        // if (_user.userRole == 'doctor') openDoctorView();
      } else {
        log.i("Error");
      }
      setBusy(false);
    }
  }

  void openDoctorView() {
    // _navigationService.navigateToDoctorView();
  }

  void openUserView() {
    // _navigationService.navigateToPatientView();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      // description: 'Give stacked $_counter stars on Github',
    );
  }
}
