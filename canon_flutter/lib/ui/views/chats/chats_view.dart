import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../models/chat.dart';
import '../../common/app_colors.dart';
import 'chats_viewmodel.dart';

class ChatsView extends StackedView<ChatsViewModel> {
  const ChatsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kcPrimaryColor,
        onPressed: viewModel.showBottomSheetUserSearch,
        label: const Row(
          children: [
            Text('New chat'),
            Icon(Icons.add_circle),
          ],
        ),
      ),
      body: Center(
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : viewModel.data?.isEmpty ?? true
                ? const Center(child: Text('No chats yet'))
                : ListView.builder(
                    itemCount: viewModel.data?.length,
                    itemBuilder: (context, index) {
                      final chat = viewModel.data![index];
                      return ChatListTile(
                        chat: chat,
                        onTap: viewModel.navigateToChat,
                        onDelete: viewModel.deleteChat,
                        isDeleting: viewModel.isChatDeleting,
                      );
                    },
                  ),
      ),
    );
  }

  @override
  ChatsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatsViewModel();

  // @override
  // void onViewModelReady(ChatsViewModel viewModel) => viewModel.onModelReady();
}

class ChatListTile extends StatelessWidget {
  final Chat chat;
  final Function(Chat) onTap;
  final Function(Chat) onDelete;
  final bool isDeleting;

  const ChatListTile({
    Key? key,
    required this.chat,
    required this.onTap,
    required this.onDelete,
    required this.isDeleting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(chat.name),
        // subtitle: Text(chat.email),
        leading: CircleAvatar(
            // backgroundImage:
            child: Text(chat.name[0])),
        trailing: isDeleting
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : IconButton(
                onPressed: () {
                  onDelete(chat);
                },
                icon: const Icon(
                  Icons.delete,
                  color: kcPrimaryColor,
                ),
              ),
        onTap: () => onTap(chat),
      ),
    );
  }
}
