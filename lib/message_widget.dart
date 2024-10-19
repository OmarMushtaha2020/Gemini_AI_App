
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key,required this.text,required this.isFromUser});
final String  text;
  final bool  isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: Container(constraints: BoxConstraints(maxWidth: 520),decoration: BoxDecoration(

        ),child: Column(
          children: [
            MarkdownBody(date)
          ],
        ),))
      ],
    );
  }
}
