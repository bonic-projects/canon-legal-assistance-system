import 'package:canon/ui/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'case_add_viewmodel.dart';

class CaseAddView extends StackedView<CaseAddViewModel> {
  const CaseAddView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CaseAddViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Legal document'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: viewModel.setName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SelectableText(
                        "Civil Cases, Criminal Cases, Family Law Cases, Labor Law Cases, Constitutional Law Cases, Intellectual Property Cases, Environmental Law Cases, Consumer Law Cases, Corporate Law Cases"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Case Class'),
                    onChanged: viewModel.setCaseClass,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a case class';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Case Type'),
                onChanged: viewModel.setCaseType,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a case type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SelectableText(
                        "Supreme Court, High Courts, District Courts, Specialized Tribunals"),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration:
                        const InputDecoration(labelText: 'Jurisdiction'),
                    onChanged: viewModel.setJurisdiction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a jurisdiction';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration:
                    const InputDecoration(labelText: 'Parties Involved'),
                onChanged: viewModel.setPartiesInvolved,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter parties involved';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Language'),
                onChanged: viewModel.setLanguage,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a language';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration:
                    const InputDecoration(labelText: 'Statutes Involved'),
                onChanged: viewModel.setStatutesInvolved,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter statutes involved';
                  }
                  return null;
                },
              ),
              if (viewModel.fileLink == null)
                CustomButton(
                  onTap: () {
                    viewModel.pickFileAndUpload(context);
                  },
                  text: 'Pick File',
                  isLoading: viewModel.isBusy,
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("File picked: ${viewModel.file!.path}"),
                ),
              // const SizedBox(height: 10),
              CustomButton(
                onTap: viewModel.addCaseFile,
                text: 'Add Case File',
                isLoading: viewModel.isBusy,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  CaseAddViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CaseAddViewModel();
}
