import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/app_styles.dart';
import '../../models/chat_model.dart';
import '../../view_models/chatbot_vm.dart';
import '../../widgets/custom_appbar.dart';

class ChatBotScreen extends StatelessWidget {
  ChatBotScreen({super.key});

  final ChatBotController controller = Get.put(ChatBotController());
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lilac.withOpacity(0.93),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomAppBar(
          title: "🤖 AI Chatbot",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Messages
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xl),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final ChatMessage msg = controller.messages[index];
                  final isUser = msg.isUser;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        gradient: isUser
                            ? AppColors.primaryGradient
                            : LinearGradient(colors: [
                          Colors.blueGrey.shade400,
                          Colors.blueGrey.shade300,
                        ]),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft:
                          Radius.circular(isUser ? 20 : 0),
                          bottomRight:
                          Radius.circular(isUser ? 0 : 20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        msg.text,
                        style: AppStyles.bodyWhite.copyWith(
                          fontSize: 17, // ✅ Bigger text
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              )),
            ),

            /// Loading indicator
            Obx(() => controller.isLoading.value
                ? Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(width: 10),
                  Text("AI is thinking...",
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            )
                : const SizedBox()),

            /// Input field
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md, vertical: AppSizes.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: "Ask me anything...",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600, fontSize: 15),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          controller.addUserMessage(value.trim());
                          _inputController.clear();
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final text = _inputController.text.trim();
                      if (text.isNotEmpty) {
                        controller.addUserMessage(text);
                        _inputController.clear();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
