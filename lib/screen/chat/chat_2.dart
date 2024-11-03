// import 'dart:async';

// import 'package:flutter/material.dart';


// class ChatWithCollaborator extends StatefulWidget
//    {
//   const ChatWithCollaborator({super.key});

//   @override
//   State<ChatWithCollaborator> createState() => _ChatWithCollaboratorState();
// }

// class _ChatWithCollaboratorState extends State<ChatWithCollaborator> {
//   GetAllChat? getAllChat;
//   bool _isLoading = true;
//   List<Conversation> messagesList = [];

//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   late IO.Socket socket;
//   late Connectivity _connectivity;
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;

//   @override
//   void initState() {
//     super.initState();
//     _connectivity = Connectivity();
//     _initializeSocket();
//     _getChat();
//     _startConnectivityListener();
//     _initializeSocketEvents();
//   }

//   void _initializeSocket() {
//     print('Initializing socket...');
//     final url =
//         'http://34.29.1.49:3004?user_id=${_user.userID}&conversation_id=${_chatController.conversationId.value}';
//     socket = IO.io(url, <String, dynamic>{
//       'transports': ['websocket'],
//     });

//     socket.onConnect((_) {
//       _chatController.getAlLGroupsChats();
//       print('Connected to socket');
//     });

//     socket.onConnectError((error) {
//       print('Connection error: $error');
//     });

//     socket.onConnectTimeout((_) {
//       print('Connection timeout');
//     });

//     socket.on('message', (data) {
//       print('Received message: $data');
//     });

//     socket.onDisconnect((_) {
//       print('Disconnected from socket');
//       _socketDisconnect();
//     });

//     socket.connect();
//   }

//   Future<void> _socketDisconnect() async {
//     await _chatController.disconnect();
//     if (_listingController.id.value != '') {
//       await _chatController.getLatestChat(_listingController.id.value);
//     }
//   }

//   Future<void> createChat() async {
//     setState(() {
//       _isLoading = true;
//       _scrollToBottom();
//     });
//     await _chatController.createChat(_user.userID, _messageController.text,
//         _chatController.propertyId.value, _chatController.folderId.value);
//     setState(() {
//       _isLoading = false;
//       // _scrollToBottom();
//     });
//   }

//   void _getChat() {
//     final messageData = {
//       "user_id": _user.userID,
//       "property_id": _chatController.propertyId.value,
//       "folder_id": _chatController.folderId.value,
//       "size": 30,
//       "skip": 0,
//     };
//     setState(() {
//       _isLoading = true;
//     });
//     print('getConversationDetail: $messageData');
//     socket.emit('getConversationDetail', messageData);
//     socket.on('chats', (data) {
//       print('chat event: $messageData');

//       getAllChat = GetAllChat.fromJson(data);
//       setState(() {
//         _isLoading = false;
//         _scrollToBottom();
//       });
//     });
//   }

//   void sendMessage(String content) {
//     final messageData = {
//       "sender_id": _user.userID,
//       "message": content,
//       "conversation_id": getAllChat!.conversationId,
//     };

//     print('sendMessasge: $messageData');
//     socket.emit('sendMessage', messageData);
//     socket.on('receiveMessage', (data) {
//       print('msg content${data["content"]}');
//       readStatus(
//           data["savedMessage"]["id"], data["savedMessage"]["created_at"]);
//     });
//   }

//   void readStatus(String msgId, String createdAt) {
//     print("datetime: $createdAt");
//     DateTime parsedDate = DateTime.parse(createdAt);
//     final messageData = {
//       "conversation_id": _chatController.conversationId.value,
//       "user_id": _user.userID,
//       "message_id": msgId,
//       "created_at": parsedDate.toLocal().toIso8601String(),
//       "date": DateTime.now().toIso8601String(),
//     };

//     print('readStatus: $messageData');

//     socket.emit('readStatus', messageData);

//     socket.on('read', (data) {
//       print('readdata: $data');
//     });
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _initializeSocketEvents() {
//     socket.on('receiveMessage', (data) {
//       print('event call${data}');

//       setState(() {
//         getAllChat!.conversation
//             .add(Conversation.fromJson(data["savedMessage"]));
//         print(getAllChat!.conversation.length);
//         _scrollToBottom();
//       });
//       readStatus(
//           data["savedMessage"]["id"], data["savedMessage"]["created_at"]);
//     });

//     socket.on('read', (data) {
//       print('status :::: ${data}');
//       // setState(() {
//       //   getAllChat!.conversation
//       //       .add(Conversation.fromJson(data["savedMessage"]));
//       //   print(getAllChat!.conversation.length);
//       //   _scrollToBottom();
//       // });
//     });
//   }

//   void _startConnectivityListener() {
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       print('Connectivity changed: $result');
//       if (result == ConnectivityResult.none) {
//         print('No internet connection');
//         if (socket.connected) {
//           socket.disconnect();
//         }
//       } else {
//         print('Internet connection available');
//         if (!socket.connected) {
//           _initializeSocket();
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     socket.dispose();
//     _connectivitySubscription.cancel();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       body: _isLoading
//           ? const ChatShimmer()
//           : NestedScrollView(
//               headerSliverBuilder:
//                   (BuildContext context, bool innerBoxIsScrolled) {
//                 return <Widget>[
//                   ConviergeAppBar(
//                     title: getAllChat?.street?.split(',').first ?? '',
//                     street: getAllChat?.folderName ?? '',
//                     ctaSection: const AddPropertyCTAButton(),
//                     backgroundImagePath: 'assets/images/listing/topbar2.png',
//                     showCTAButton: false,
//                     multiScreen: true,
//                     isChatScreen: true,
//                     propertyInFolder: () => _folderChatBottomSheet(context),
//                     shareUserSection: buildSharedUsersRow(),
//                   ),
//                 ];
//               },
//               body: GestureDetector(
//                 onTap: () {
//                   FocusScope.of(context).requestFocus(new FocusNode());
//                 },
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: MediaQuery.removePadding(
//                         removeTop: true,
//                         context: context,
//                         child: ListView.builder(
//                           controller: _scrollController,
//                           padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
//                           itemCount: getAllChat!.conversation.length,
//                           itemBuilder: (context, index) {
//                             final message = getAllChat!.conversation[index];
//                             final timestamp = Helpers.formatting
//                                 .daysFromCreatedAt(message.createdAt);
//                             final isSender = message.senderId == _user.userID;

//                             return Align(
//                               alignment: isSender
//                                   ? Alignment.centerRight
//                                   : Alignment.centerLeft,
//                               child: Row(
//                                 mainAxisAlignment: isSender
//                                     ? MainAxisAlignment.end
//                                     : MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (!isSender)
//                                     Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 8.0),
//                                       child: CircleAvatar(
//                                         backgroundColor: Colors.grey[200],
//                                         radius: 16,
//                                         backgroundImage: NetworkImage(
//                                             message.user.profileImageUrl),
//                                       ),
//                                     ),
//                                   Container(
//                                     constraints: BoxConstraints(
//                                       maxWidth:
//                                           MediaQuery.of(context).size.width *
//                                               0.7,
//                                     ),
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 5.0),
//                                     padding: const EdgeInsets.all(10.0),
//                                     decoration: BoxDecoration(
//                                       color: isSender
//                                           ? theme.colorScheme.primary
//                                           : theme.colorScheme.onBackground,
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         if (!isSender)
//                                           Text(
//                                             '${message.user.firstname} ${message.user.lastname}',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: isSender
//                                                   ? Colors.white
//                                                   : theme.colorScheme.onSurface,
//                                             ),
//                                           ),
//                                         const SizedBox(height: 5),
//                                         Row(
//                                           mainAxisAlignment: isSender
//                                               ? MainAxisAlignment.end
//                                               : MainAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 message.content,
//                                                 style: TextStyle(
//                                                   color: isSender
//                                                       ? Colors.white
//                                                       : theme.colorScheme
//                                                           .onSurface,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 5),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               timestamp,
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: isSender
//                                                     ? Colors.white
//                                                     : theme
//                                                         .colorScheme.onSurface
//                                                         .withOpacity(0.5),
//                                               ),
//                                             ),
//                                             isSender
//                                                 ? Icon(
//                                                     message.status == "read"
//                                                         ? Icons.done_all
//                                                         : Icons.check,
//                                                     size: 15,
//                                                     color: Colors.white,
//                                                   )
//                                                 : const SizedBox()
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   if (isSender)
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 8.0),
//                                       child: CircleAvatar(
//                                         backgroundColor: Colors.grey[200],
//                                         radius: 16,
//                                         backgroundImage: NetworkImage(
//                                             message.user.profileImageUrl),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(15, 10, 15, 26),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _messageController,
//                               minLines: 1,
//                               maxLines: 8,
//                               decoration: InputDecoration(
//                                 hintText: 'Type a message',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 filled: true,
//                                 fillColor: theme.colorScheme.background,
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.send),
//                             onPressed: () async {
//                               if (_messageController.text.isNotEmpty) {
//                                 if (getAllChat?.conversationId != null) {
//                                   sendMessage(_messageController.text);
//                                   _messageController.clear();
//                                 } else {
//                                   await createChat();
//                                   _getChat();
//                                   _messageController.clear();
//                                 }
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget buildSharedUsersRow() {
//     return Row(
//       children: List.generate(
//         getAllChat!.sharedUsers.length,
//         (index) => CircleAvatar(
//           backgroundColor: Colors.grey[200],
//           radius: 14,
//           backgroundImage:
//               NetworkImage(getAllChat!.sharedUsers[index].profileImageUrl),
//         ),
//       ),
//     );
//   }

//   void _folderChatBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       isDismissible: true,
//       isScrollControlled: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//       ),
//       builder: (context) {
//         return Theme(
//           data: Theme.of(context),
//           child: FolderChat(id: getAllChat!.propertyID!),
//         );
//       },
//     );
//   }
// }
