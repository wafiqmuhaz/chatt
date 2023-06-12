// ignore_for_file: prefer_const_declarations, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';

import '../models/message_group.dart';
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
  Map<String, dynamic> _replyToMessage = {};

  void _sendMessage(String groupId, String senderName) {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      chatProvider.sendMessage(groupId, message, senderName,
          replyToMessageId: _replyToMessage['messageId'] ?? '',
          replyToSenderName: _replyToMessage['senderName'] ?? '',
          replyToContent: _replyToMessage['message'] ?? '');
      _messageController.clear();
      _clearReplyToMessage();
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

      chatProvider.sendImage(groupId, senderName, _imageFile!,
          replyToMessageId: _replyToMessage['messageId'] ?? '',
          replyToSenderName: _replyToMessage['senderName'] ?? '',
          replyToContent: _replyToMessage['message'] ?? '');
      setState(() {
        _imageFile = null;
      });
      _clearReplyToMessage();
    }
  }

  void _replyToMessageData(Map<String, dynamic> message) {
    setState(() {
      _replyToMessage = message;
    });
  }

  void _clearReplyToMessage() {
    setState(() {
      _replyToMessage = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final String groupId =
        'your_group_id'; // Ganti dengan ID grup chat yang sesuai
    final String senderName = 'John Doe'; // Ganti dengan nama pengirim

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Group'),
        backgroundColor: Color(0xFFc9f7f5),
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
                    final String replyToMessageId =
                        message['replyToMessageId'] ?? '';
                    final String replyToSenderName =
                        message['replyToSenderName'] ?? '';
                    final String replyToContent =
                        message['replyToContent'] != null
                            ? message['replyToContent']
                            : '';

                    final isSender = senderName == senderName;

                    final currentMessage = MessageGroup(
                      messageId: messages[index].id,
                      message: content,
                      senderName: senderName,
                      imageUrl: imageUrl,
                      replyToMessageId: replyToMessageId,
                      replyToSenderName: replyToSenderName,
                      replyToContent: replyToContent,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SwipeTo(
                        onRightSwipe: () {
                          // var dataPesan = _replyToMessageData(message);
                          _replyToMessageData(message);
                          print('message ===> $message');
                        },
                        child: ChatBubble(
                          clipper: isSender
                              ? ChatBubbleClipper9(
                                  type: BubbleType.sendBubble,
                                )
                              : ChatBubbleClipper8(
                                  type: BubbleType.receiverBubble,
                                ),
                          alignment:
                              isSender ? Alignment.topRight : Alignment.topLeft,
                          margin: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          backGroundColor:
                              isSender ? Color(0xFFc9f7f5) : Colors.green,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.5,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSender ? Color(0xFFc9f7f5) : Colors.green,
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (replyToContent.isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFbcdaf7),
                                      borderRadius: BorderRadius.circular(
                                        8.0,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              if (replyToContent.isNotEmpty)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0XFF6bb5ff),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(
                                                        8.0,
                                                      ),
                                                      topLeft: Radius.circular(
                                                        8.0,
                                                      ),
                                                    ),
                                                  ),
                                                  width: 7.0,
                                                ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // berikan kode agar bisa mereply teks dan image
                                                      Text(
                                                        replyToContent,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    // mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Text(senderName),
                                      if (imageUrl.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(
                                            8.0,
                                          ),
                                          child: Image.network(
                                            imageUrl,
                                          ),
                                        )
                                      else
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(content),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                child: Column(
                  children: [
                    if (_replyToMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'Pesan yang direply:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8.0),
                            if (_replyToMessage.containsKey('imageUrl') &&
                                _replyToMessage['imageUrl'].isNotEmpty)
                              Image.network(
                                _replyToMessage['imageUrl'],
                                width: 100,
                                height: 100,
                              )
                            else
                              Flexible(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    _replyToMessage['message'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    Row(
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
