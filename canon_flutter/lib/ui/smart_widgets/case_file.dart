import 'dart:io';

import 'package:open_file_plus/open_file_plus.dart';
import 'package:stacked/stacked.dart';

import '../../app/app.logger.dart';
import '../../models/case.dart';
import 'package:flutter/material.dart';

import '../../services/storage_service.dart';

class CaseFileWidget extends StatelessWidget {
  final CaseModel caseFile;

  const CaseFileWidget({Key? key, required this.caseFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CaseFileViewModel>.reactive(
      viewModelBuilder: () => CaseFileViewModel(),
      onModelReady: (viewModel) => viewModel.setCaseFile(caseFile),
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: viewModel.fileDownload,
              title: Text(viewModel.caseFile.name),
              subtitle: Text(
                'Case Class: ${viewModel.caseFile.caseClass}, Jurisdiction: ${viewModel.caseFile.jurisdiction}',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CaseFileViewModel extends BaseViewModel {
  final log = getLogger('CaseFileViewModel');
  late CaseModel _caseFile;
  final StorageService _storageService = StorageService();

  CaseModel get caseFile => _caseFile;

  void setCaseFile(CaseModel caseFile) {
    _caseFile = caseFile;
    notifyListeners();
  }

  Future fileDownload() async {
    // log.i("Started");
    File? downloaded = await _storageService.downloadFileWithUrl(
        _caseFile.fileLink, _caseFile.format);
    log.i(downloaded);
    if (downloaded != null) {
      OpenFile.open(downloaded.path);
    }
  }
}
