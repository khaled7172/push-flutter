import 'package:flutter/material.dart';

class GeneralChatScreen extends StatelessWidget {
  final String majorName;

  const GeneralChatScreen({
    super.key,
    required this.majorName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$majorName General Chat"),
      ),
      body: const Center(
        child: Text(
          "General Chat Room",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}