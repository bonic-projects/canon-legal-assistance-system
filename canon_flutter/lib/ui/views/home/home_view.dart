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
      // appBar: AppBar(
      //   title: const Text('Doctor Robo'),
      // ),
      body: GridView.count(
        crossAxisCount: 1,
        children: [
          Option(
              name: 'Doctor',
              onTap: viewModel.openDoctorView,
              file: 'assets/lottie/doctor.json'),
          Option(
              name: 'Patient',
              onTap: viewModel.openUserView,
              file: 'assets/lottie/users.json'),
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
