import 'package:canon/app/app.bottomsheets.dart';
import 'package:canon/app/app.locator.dart';
import 'package:canon/app/app.logger.dart';
import 'package:canon/models/appuser.dart';
import 'package:canon/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'register_view.form.dart';
import 'package:canon/app/app.router.dart';

class RegisterViewModel extends FormViewModel {
  final log = getLogger('RegisterViewModel');
  final _userService = locator<UserService>();

  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  // late String _userRole;
  // String get userRole => _userRole;

  void onModelReady() {
    // _userRole = userRole;
  }

  void registerUser() async {
    if ((hasType &&
            typeValue == "lawyer" &&
            isFormValid &&
            hasEmail &&
            hasSpecialization &&
            hasPassword &&
            hasName) ||
        (hasType &&
            typeValue == "client" &&
            hasEmail &&
            hasPassword &&
            hasName)) {
      setBusy(true);
      log.i("email and pass valid");
      log.i(emailValue!);
      log.i(passwordValue!);
      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService!.createAccountWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        String? error = await _userService.createUpdateUser(
          AppUser(
            id: result.user!.uid,
            fullName: nameValue!,
            registeredOn: DateTime(2022),
            email: result.user!.email!,
            userRole: typeValue!,
            specialization: specializationValue ?? "",
            ratings: [],
          ),
        );
        if (error == null) {
          await _userService.fetchUser();
          _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
        } else {
          log.i("Firebase error");
          _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.alert,
            title: "Upload Error",
            description: error,
          );
        }
      } else {
        log.i("Error: ${result.errorMessage}");
        _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.alert,
          title: "Error",
          description: result.errorMessage ?? "Enter valid credentials",
        );
      }
    }
    setBusy(false);
  }
}
