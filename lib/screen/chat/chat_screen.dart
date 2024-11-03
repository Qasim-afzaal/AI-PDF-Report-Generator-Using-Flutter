import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:tradelinkedai/core/providers/main_provider.dart';
import 'package:tradelinkedai/models/msgs_model.dart';

import 'package:tradelinkedai/core/providers/auth.dart';
import 'package:dio/dio.dart'; // For downloading PDF
import 'package:path_provider/path_provider.dart'; // For storing PDF locally
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For PDF viewing

class ChatPage extends StatefulWidget {
  final String userId;
  final String conversationId;
  String chatnRoom;
  bool boolnewchat;
  final String userName;
  final String chatName;

  ChatPage({
    super.key,
    required this.userId,
    required this.chatnRoom,
    required this.userName,
    required this.conversationId,
    required this.boolnewchat,
    required this.chatName,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  AuthProvider? authProvider;
  final List<Message> _currentChatMessages = [];
  String? _pdfPath; // To store the local path of the downloaded PDF

  List<Message> get currentChatMessages => _currentChatMessages;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      getConversation();

      chatProvider.connectToChat();
      print(widget.boolnewchat);
    });
  }

  void getConversation() {
    final chatData = {
      "conversation_id": widget.conversationId,
      "size": 100,
      "skip": 0,
    };

    Provider.of<ChatProvider>(context, listen: false).storeBody(chatData);
  }

  void _startChat(String content) {
    final chatData = {
      'user_id': widget.userId,
      'name': widget.chatName,
      'text': content,
    };

    Provider.of<ChatProvider>(context, listen: false).startChat(chatData);
    widget.boolnewchat = false;
    Provider.of<ChatProvider>(context, listen: false)
        .storebool(widget.boolnewchat);
    setState(() {});
    _messageController.clear();
  }

  void _sendMessage(String content) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(
          widget.userId,
          Provider.of<ChatProvider>(context, listen: false).currentChatName!,
          content);

      _messageController.clear();
    }
  }

  Widget _buildMessageBubble(Message message) {
    bool isSender = message.senderId == widget.userId;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isSender ? Colors.blueAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isSender ? 12 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content!,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            if (message.fileUrl != null &&
                message.fileUrl!.isNotEmpty &&
                message.msgType == 'pdf_file')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.red),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      await _downloadPdf(message.fileUrl!);
                      if (_pdfPath != null) {
                        _showPdfPreviewDialog(context);
                      }
                    },
                    child: Text(
                      'Open PDF',
                      style: TextStyle(
                        color: isSender ? Colors.white : Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            if (message.content?.toLowerCase() == "done" &&
                message.msgType == "pdf_file" &&
                message.fileUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'PDF available:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      await _downloadPdf(message.fileUrl!);
                      if (_pdfPath != null) {
                        _showPdfPreviewDialog(context);
                      }
                    },
                    child: Text(
                      "", // message.fileUrl!,
                      style: TextStyle(
                        color: isSender ? Colors.white : Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPdf(String url) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Downloading PDF...'),
        ),
      );

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/downloaded.pdf';

      Dio dio = Dio();
      await dio.download(url, filePath);

      bool fileExists = await File(filePath).exists();
      if (fileExists) {
        setState(() {
          _pdfPath = filePath;
        });

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF downloaded successfully!'),
          ),
        );
      } else {
        throw Exception("File not found after downloading");
      }
    } catch (e) {
      print("Error downloading PDF: $e");
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not download PDF'),
        ),
      );
    }
  }

  Future<void> chatClear() async {
    print("i am calling");

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.clearChat(chatProvider.currentChatName!);
  }

  void _showPdfPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PDF Preview'),
          content: Container(
            height: 400,
            width: 300,
            child: _pdfPath != null
                ? PDFView(
                    filePath: _pdfPath!,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageSnap: true,
                    onError: (error) {
                      print(error);
                    },
                    onPageError: (page, error) {
                      print('Page $page: $error');
                    },
                  )
                : const Text('Failed to load PDF'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Phoenix.rebirth(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Text(widget.chatnRoom ?? 'Chat');
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // final chatProvider = Provider.of<ChatProvider>(context, listen: false);
              //  chatProvider.currentChatName ="";
              // Navigator.pop(context);
              Phoenix.rebirth(context);
            },
          ),
        ),
        body: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            if (chatProvider.loadingState == LoadingState.loading) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      final messages = chatProvider.currentChatMessages;

                      return messages.isEmpty
                          ? const Center(
                              child: Text(
                                'No messages yet. Start the conversation!',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              padding: const EdgeInsets.all(8.0),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final reversedIndex =
                                    messages.length - 1 - index;
                                final message = messages[reversedIndex];
                                return _buildMessageBubble(message);
                              },
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () async {
                              chatClear();
                              Phoenix.rebirth(context);
                            },
                            child: Icon(Icons.delete)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                        ),
                      ),
                      chatProvider.currentChatMessages
                              .where((msg) => msg.fileUrl != null &&  msg.fileUrl != "")
                              .isNotEmpty
                          ? SizedBox() // Show nothing if no valid file URLs
                          : IconButton(
                              icon: const Icon(Icons.send,
                                  color: Colors.blueAccent),
                              onPressed: Provider.of<ChatProvider>(context)
                                      .isChatEnabled
                                  ? () {
                                      widget.boolnewchat == true
                                          ? _startChat(_messageController.text)
                                          : _sendMessage(
                                              _messageController.text);
                                    }
                                  : null,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            );
          },
        ),
      ),
    );
  }
}
