import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatProvider {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ChatProvider({
    required this.firestore,
    required this.storage,
  });

  Future<void> sendMessage(
    String groupId,
    String message,
    String senderName, {
    String replyToMessageId = '',
    String replyToSenderName = '',
    String replyToContent = '',
  }) async {
    await firestore
        .collection('group_chats')
        .doc(groupId)
        .collection('messages')
        .add({
      'message': message,
      'senderName': senderName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'replyToMessageId': replyToMessageId,
      'replyToSenderName': replyToSenderName,
      'replyToContent': replyToContent,
    });
  }

  Future<void> sendImage(
    String groupId,
    String senderName,
    File image, {
    String replyToMessageId = '',
    String replyToSenderName = '',
    String replyToContent = '',
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference storageReference =
        storage.ref().child('group_chats/$groupId/images/$fileName');
    final UploadTask uploadTask = storageReference.putFile(image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    final imageUrl = await taskSnapshot.ref.getDownloadURL();

    await firestore
        .collection('group_chats')
        .doc(groupId)
        .collection('messages')
        .add({
      'imageUrl': imageUrl,
      'senderName': senderName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'replyToMessageId': replyToMessageId,
      'replyToSenderName': replyToSenderName,
      'replyToContent': replyToContent,
    });
  }
}
