import 'dart:io';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/case.dart';
import '../../../services/firestore_service.dart';
import '../../../services/storage_service.dart';

class CaseAddViewModel extends BaseViewModel {
  final log = getLogger('CaseAddViewModel');

  final _storageService = locator<StorageService>();
  final _firestoreSerivce = locator<FirestoreService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _name;
  String? _caseClass;
  String? _caseType;
  String? _jurisdiction;
  List<String>? _partiesInvolved;
  String? _language;
  List<String>? _statutesInvolved;
  String? _fileLink;
  String? get fileLink => _fileLink;
  String? _id;

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setCaseClass(String value) {
    _caseClass = value;
    notifyListeners();
  }

  void setCaseType(String value) {
    _caseType = value;
    notifyListeners();
  }

  void setJurisdiction(String value) {
    _jurisdiction = value;
    notifyListeners();
  }

  void setPartiesInvolved(String value) {
    _partiesInvolved =
        value.split(',').map((parties) => parties.trim()).toList();
    notifyListeners();
  }

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  void setStatutesInvolved(String value) {
    _statutesInvolved =
        value.split(',').map((statutes) => statutes.trim()).toList();
    notifyListeners();
  }

  File? file;

  Future<void> pickFileAndUpload(context) async {
    setBusy(true);
    Directory? externalDir = await getExternalStorageDirectory();
    String? path = await FilesystemPicker.open(
      title: 'Open file',
      context: context,
      rootDirectory: externalDir!,
      fsType: FilesystemType.file,
      allowedExtensions: ['.txt'],
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
    if (path != null) {
      file = File(path);
      _id = _firestoreSerivce.getCaseDocumentId();
      log.i(file!.path);
      try {
        _fileLink = await _storageService.uploadFile(file!, "caseFiles/$_id/");
      } catch (e) {
        log.e(e);
      }
      notifyListeners();
    } else {
      // User canceled the file picking
      // Handle accordingly
    }
    setBusy(false);
  }

  Future<void> addCaseFile() async {
    setBusy(true);
    if (formKey.currentState!.validate() && _fileLink != null) {
      CaseModel caseFile = CaseModel(
        name: _name!,
        caseClass: _caseClass!,
        caseType: _caseType!,
        jurisdiction: _jurisdiction!,
        partiesInvolved: _partiesInvolved!,
        language: _language!,
        statutesInvolved: _statutesInvolved!,
        fileLink: _fileLink!,
        id: _id!,
        date: DateTime.now(),
      );

      try {
        // Save the case file to Firestore
        await _firestoreSerivce.addCaseFile(caseFile);

        // Reset the form or navigate to a different screen after saving
      } catch (e) {
        // Handle error while saving
        log.e('Error adding case file: $e');
      }
    }
    setBusy(false);
  }
}
