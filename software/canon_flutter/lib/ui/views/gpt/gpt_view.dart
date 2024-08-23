import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'gpt_viewmodel.dart';

class GptView extends StackedView<GptViewModel> {
  const GptView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    GptViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document summarization'),
        actions: [
          if (viewModel.isBusy)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final message = viewModel.messages.reversed.toList()[index];
                return ChatMessageTile(
                  content: message.content,
                  isUser: message.isUser,
                );
              },
            ),
          ),
          const Divider(),
          const ChatInputField(),
        ],
      ),
    );
  }

  @override
  GptViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      GptViewModel();

  @override
  void onViewModelReady(GptViewModel viewModel) => viewModel.onModelReady();
}

class ChatMessageTile extends StatelessWidget {
  final String content;
  final bool isUser;

  const ChatMessageTile(
      {super.key, required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isUser ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class ChatInputField extends ViewModelWidget<GptViewModel> {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context, GptViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.words,
              controller: viewModel.messageController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: viewModel.sendMessage,
          ),
        ],
      ),
    );
  }
}
