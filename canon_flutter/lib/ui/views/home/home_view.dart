import 'package:canon/ui/widgets/option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canon'),
        actions: [
          if (viewModel.user != null)
            IconButton(
              onPressed: viewModel.logout,
              icon: const Icon(Icons.logout),
            )
        ],
      ),
      body: ListView(
        children: [
          Option(
              name: 'Summarization',
              onTap: viewModel.openDoctorView,
              file: 'assets/lottie/ai.json'),
          Option(
              name: 'Legal documents',
              onTap: viewModel.openUserView,
              file: 'assets/lottie/legal.json'),
          Option(
              name:
                  viewModel.user!.userRole == 'lawyer' ? "Clients" : 'Lawyers',
              onTap: viewModel.openUserView,
              file:
                  'assets/lottie/${viewModel.user!.userRole == 'lawyer' ? "lawyers" : 'users'}.json'),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
