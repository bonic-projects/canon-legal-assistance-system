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
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            if (viewModel.isBusy)
              const Center(child: CircularProgressIndicator())
            else if (viewModel.hasError)
              Text('Error: ${viewModel.error}')
            else
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // DropdownButton<String>(
                        //   value: viewModel.selectedCaseClass,
                        //   hint: const Text('Select Case Class'),
                        //   items: viewModel.caseClasses
                        //       .map((caseClass) => DropdownMenuItem(
                        //             value: caseClass,
                        //             child: Text(caseClass),
                        //           ))
                        //       .toList(),
                        //   onChanged: viewModel.setSelectedCaseClass,
                        // ),
                        const SizedBox(width: 16),
                        // DropdownButton<String>(
                        //   value: viewModel.selectedJurisdiction,
                        //   hint: const Text('Select Jurisdiction'),
                        //   items: viewModel.jurisdictions
                        //       .map((jurisdiction) => DropdownMenuItem(
                        //             value: jurisdiction,
                        //             child: Text(jurisdiction),
                        //           ))
                        //       .toList(),
                        //   onChanged: viewModel.setSelectedJurisdiction,
                        // ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.cases.length,
                        itemBuilder: (context, index) {
                          CaseModel caseFile = viewModel.cases[index];
                          return ListTile(
                            title: Text(caseFile.name),
                            subtitle: Text(
                                'Case Class: ${caseFile.caseClass}, Jurisdiction: ${caseFile.jurisdiction}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
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
