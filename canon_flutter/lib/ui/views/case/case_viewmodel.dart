import 'package:canon/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/case.dart';
import '../../../services/firestore_service.dart';
import '../../../services/user_service.dart';

class CaseViewModel extends BaseViewModel {
  final log = getLogger('CaseViewModel');

  final _navigationService = locator<NavigationService>();
  // final _dialogService = locator<DialogService>();
  // final _bottomSheetService = locator<BottomSheetService>();
  final _firestoreSerivce = locator<FirestoreService>();

  final _userService = locator<UserService>();
  bool get hasUser => _userService.hasLoggedInUser;
  AppUser? get user => _userService.user;

  void openCaseAddView() {
    _navigationService.navigateToCaseAddView();
  }

  List<CaseModel> _cases = [];
  List<CaseModel> get cases => _cases;

  final List<String> _caseClasses = [
    'Civil Cases',
    'Criminal Cases',
    'Family Law Cases',
    'Labor Law Cases',
    'Constitutional Law Cases',
    'Intellectual Property Cases',
    'Environmental Law Cases',
    'Consumer Law Cases',
    'Corporate Law Cases',
  ];
  List<String> get caseClasses => _caseClasses;

  final List<String> _jurisdictions = [
    'Supreme Court',
    'High Courts',
    'District Courts',
    'Specialized Tribunals',
  ];
  List<String> get jurisdictions => _jurisdictions;

  String _selectedCaseClass = '';
  String get selectedCaseClass => _selectedCaseClass;

  String _selectedJurisdiction = '';
  String get selectedJurisdiction => _selectedJurisdiction;

  Future<void> fetchCases({int limit = 10}) async {
    try {
      _cases = await _firestoreSerivce.fetchCases(
              selectedJurisdiction: _selectedJurisdiction,
              selectedCaseClass: _selectedCaseClass) ??
          <CaseModel>[];
      notifyListeners();
    } catch (e) {
      // Handle error while fetching cases
      log.e('Error fetching cases: $e');
    }
  }

  void setSelectedCaseClass(String? value) {
    _selectedCaseClass = value ?? '';
    fetchCases();
  }

  void setSelectedJurisdiction(String? value) {
    _selectedJurisdiction = value ?? '';
    fetchCases();
  }
}
