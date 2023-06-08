// ignore_for_file: prefer_const_declarations

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/group_chat_provider.dart';

class GroupChatPage extends StatefulWidget {
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final ChatProvider chatProvider = ChatProvider(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
  final TextEditingController _messageController = TextEditingController();
  File? _imageFile;

  void _sendMessage(String groupId, String senderName) {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      chatProvider.sendMessage(groupId, message, senderName);
      _messageController.clear();
    }
  }

  Future<void> _sendImage(String groupId, String senderName) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      chatProvider.sendImage(groupId, senderName, _imageFile!);
      setState(() {
        _imageFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String groupId =
        'your_group_id'; // Ganti dengan ID grup chat yang sesuai
    final String senderName = 'John Doe'; // Ganti dengan nama pengirim

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.firestore
                  .collection('group_chats')
                  .doc(groupId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final String senderName = message['senderName'];
                    final String content = message['message'] ?? '';
                    final String imageUrl = message['imageUrl'] ?? '';

                    final isSender = senderName == senderName;

                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: isSender
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(senderName),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: isSender
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (imageUrl.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? const Color(0xFFe1f0ff)
                                      : const Color(0xFFc9f7f5),
                                  borderRadius: BorderRadius.circular(
                                    22,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      imageUrl,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? const Color(0xFFe1f0ff)
                                      : const Color(0xFFc9f7f5),
                                  borderRadius: BorderRadius.circular(
                                    22,
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    content,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFebedf2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ketik di sini',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () => _sendImage(groupId, senderName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(groupId, senderName),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
