import '../app/app.logger.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class GptChatService {
  final log = getLogger('GptService');

  final openAI = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
      enableLog: true);

  Future<String> getGptReply({
    String? text,
    bool isSum = false,
  }) async {
    ChatCompleteText request;
    // request = ChatCompleteText(messages: [
    //   Map.of({"role": "user", "content": text})
    // ], maxToken: 1000, model: ChatModel.gptTurbo0301);
    List<Map<String, String>> messages = [
      {
        "role": "system",
        "content":
            "You are a helpful assistant for legal app. And now act as a legal document summarization helper."
      },
    ];
    if (text == null) {
      log.e("error");
      messages.add(
        {
          "role": "user",
          "content": "Help me to Summarize some legal documents"
        },
      );
    } else if (isSum) {
      log.e(text);
      messages.add(
        {"role": "user", "content": "Summarize this: \"$text\""},
      );
    } else {
      messages.add(
        {"role": "user", "content": text},
      );
    }
    request = ChatCompleteText(
        messages: messages, maxToken: 200, model: ChatModel.gptTurbo0301);

    try {
      ChatCTResponse? res = await openAI.onChatCompletion(request: request);
      log.i(
          "request ${res?.choices.length} ${res?.choices.first.message?.content}");
      if (res != null && res.choices.isNotEmpty) {
        return res.choices.first.message?.content ?? "Error in text";
      } else {
        return "Error";
      }
    } catch (e) {
      log.e(e);
      return "Error";
    }
  }

  //
  // Future<void> getGptReply(String text, {bool isFirst = false}) async {
  //   log.i(text);
  //   Completion? completion;
  //   try {
  //     completion = await chatGpt.textCompletion(
  //       request: CompletionRequest(
  //         prompt: "hello",
  //         maxTokens: 200,
  //       ),
  //     );
  //   } catch (e) {
  //     log.e("Error: $e");
  //   }
  //
  //   if (completion != null) {
  //     log.i(
  //         "Completion: ${completion.choices!.length} ${completion.choices!.first.text}");
  //   } else {
  //     log.e("Error");
  //   }
  // }
}
