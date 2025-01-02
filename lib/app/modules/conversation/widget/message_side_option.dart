import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/conversation_messages_res.dart';

class MessageSideOption extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffold;
  final Participant? participant;
  const MessageSideOption(this.scaffold,
      {super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Get.width * .5,
        height: double.infinity,
        color: Colors.white,
        child: const Column(
          children: [],
        ),
      ),
    );
  }
}
