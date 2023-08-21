import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatMessage extends StatefulWidget {
  const NewChatMessage({super.key});

  @override
  State<NewChatMessage> createState() => _NewChatMessageState();
}

class _NewChatMessageState extends State<NewChatMessage> {
  final newMessageController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    newMessageController.dispose();
  }

  void submitMessage() async {
    final enterMessage = newMessageController.text;
    if (enterMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();

    newMessageController.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userData =
        await FirebaseFirestore.instance.collection("user").doc(user.uid).get();
    await FirebaseFirestore.instance.collection("chat").add({
      'text': enterMessage,
      'createdAt': Timestamp.now(),
      'userID': user.uid,
      'userName': userData.data()!['username'],
      'imageURL': userData.data()!['imageURL'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: newMessageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "Send a Message..."),
            ),
          ),
          IconButton(
            onPressed: submitMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
