import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gapshap/widget/bubble_message.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatsnapchot) {
          if (chatsnapchot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatsnapchot.hasData || chatsnapchot.data!.docs.isEmpty) {
            return const Center(child: Text("No Message Found"));
          }
          if (chatsnapchot.hasError) {
            return const Center(child: Text("Something went Wrong!"));
          }
          final loadedMessages = chatsnapchot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index].data();
              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;

              final currentMessageUserID = chatMessage['userID'];

              final nextMessageUserID =
                  nextChatMessage != null ? nextChatMessage['userID'] : null;
              final nextUserNameSame =
                  nextMessageUserID == currentMessageUserID;
              if (nextUserNameSame) {
                return Message.next(
                    message: chatMessage['text'],
                    isMe: authUser.uid == currentMessageUserID);
              } else {
                return Message.first(
                    userImage: chatMessage['imageURL'],
                    username: chatMessage['userName'],
                    message: chatMessage['text'],
                    isMe: authUser.uid == currentMessageUserID);
              }
            },
            itemCount: loadedMessages.length,
          );
        });
  }
}
