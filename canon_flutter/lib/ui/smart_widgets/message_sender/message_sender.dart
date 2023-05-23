import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../models/chat.dart';
import 'message_sendermodel.dart';

class MessageSender extends StackedView<MessageSenderModel> {
  final Chat chat;
  const MessageSender({Key? key, required this.chat}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MessageSenderModel viewModel,
    Widget? child,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: viewModel.messageController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message...',
                ),
              ),
            ),
            // if (viewModel.progress != 0 || viewModel.isBusy)
            if (viewModel.progress != 0 || viewModel.isBusy)
              const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(strokeWidth: 2))
            else if (viewModel.fileSelected != null)
              IconButton(
                icon: const Icon(
                  Icons.file_download_done,
                  color: Colors.green,
                ),
                onPressed: viewModel.filePicker,
              )
            else
              IconButton(
                icon: const Icon(Icons.file_present),
                onPressed: viewModel.filePicker,
              ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: viewModel.messageController.text.isNotEmpty ||
                      viewModel.fileSelected != null
                  ? viewModel.sendMessage
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  MessageSenderModel viewModelBuilder(
    BuildContext context,
  ) =>
      MessageSenderModel(chat: chat);

  @override
  void onViewModelReady(MessageSenderModel viewModel) =>
      viewModel.onModelReady();
}
