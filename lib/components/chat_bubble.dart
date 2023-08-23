import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final BorderRadius borderRadius;

  final Color color;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.borderRadius,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color,
      ),
      child: Text(message,
          style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
