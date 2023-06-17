import 'package:canon/ui/smart_widgets/case_file.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/case.dart';
import '../../common/app_colors.dart';
import 'case_viewmodel.dart';

class CaseView extends StackedView<CaseViewModel> {
  const CaseView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CaseViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Legal documents"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (viewModel.user != null && viewModel.user!.userRole == "lawyer")
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 150,
                  ),
                ),
                CustomButtonSelector(
                    onTap: viewModel.openCaseAddView, text: "Add case file"),
              ],
            ),
          if (viewModel.isBusy)
            const Center(child: CircularProgressIndicator())
          else if (viewModel.hasError)
            Text('Error: ${viewModel.error}')
          else
            Expanded(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Case class: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          DropdownButton<String>(
                            value: viewModel.selectedCaseClass.isEmpty
                                ? viewModel.caseClasses[0]
                                : viewModel.selectedCaseClass,
                            hint: const Text('Select Case Class'),
                            items:
                                viewModel.caseClasses.toList().map((caseClass) {
                              return DropdownMenuItem<String>(
                                value: caseClass,
                                child: Text(caseClass),
                              );
                            }).toList(),
                            onChanged: viewModel.setSelectedCaseClass,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Jurisdiction: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          DropdownButton<String>(
                            value: viewModel.selectedJurisdiction.isEmpty
                                ? viewModel.jurisdictions.first
                                : viewModel.selectedJurisdiction,
                            hint: const Text('Select Jurisdiction'),
                            items: viewModel.jurisdictions
                                .map((jurisdiction) => DropdownMenuItem(
                                      value: jurisdiction,
                                      child: Text(jurisdiction),
                                    ))
                                .toList(),
                            onChanged: viewModel.setSelectedJurisdiction,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.cases.length,
                      itemBuilder: (context, index) {
                        CaseModel caseFile = viewModel.cases[index];
                        return CaseFileWidget(caseFile: caseFile);
                      },
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  CaseViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CaseViewModel();

  @override
  void onViewModelReady(CaseViewModel viewModel) {
    viewModel.fetchCases();
    super.onViewModelReady(viewModel);
  }
}

class CustomButtonSelector extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CustomButtonSelector({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: kcPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.add),
                ],
              ),
            )),
      ),
    );
  }
}
