import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tradelinkedai/core/constants/app_globals.dart';
import 'package:tradelinkedai/core/constants/constants.dart';
import 'package:tradelinkedai/models/msgs_model.dart';
import 'package:tradelinkedai/services/api_repository.dart';

enum LoadingState { loading, loaded, error }

class ChatProvider with ChangeNotifier {
  // Current active chat name
  String? _currentChatName;

  String? get currentChatName => _currentChatName;
  set currentChatName(String? chatName) {
    _currentChatName = chatName;
    notifyListeners(); // Notify listeners when the current chat name is updated
  }

  // List of messages in the current chat
  final List<Message> _currentChatMessages = [];

  List<Message> get currentChatMessages => _currentChatMessages;

  bool _isChatEnabled = true; // Track if the chat is enabled
  bool get isChatEnabled => _isChatEnabled;

  // Socket instance
  IO.Socket? _socket;

  IO.Socket? get socket => _socket;

  Map<String, dynamic>? _body;

  void storeBody(Map<String, dynamic> data) {
    _body = data;
    notifyListeners();
  }

  bool _data = false;
  void storebool(bool data) {
    _data = data;
    print("noool@$_data");
    notifyListeners();
  }

  // Loader variable
  LoadingState _loadingState = LoadingState.loaded;

  LoadingState get loadingState => _loadingState;

  void setLoadingState(LoadingState state) {
    _loadingState = state;
    notifyListeners();
  }

  // Connect to the current chat
  void connectToChat() {
    // Connect to the socket
    _socket = IO.io(
      Constants.socketBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();
    print(_data);
    if (_data == false) {
      setLoadingState(LoadingState.loading);
    }

    // Register socket event listeners
    _socket!.onConnect((_) {
      print("Connected to the socket $_body");
      if (_data == false) {
        if (_body != null) {
          _socket!.emit(Constants.getConversationDetail, _body);
        } else {
          print("Error: _body is null");
        }
      }
    });

    // Listener for receiving messages
    _socket!.on("receiveConversation", (data) {
      setLoadingState(LoadingState.loaded); // Set loading state to loaded

      // Extract the list of formatted messages from the data
      if (data != null && data["formattedMessages"] is List) {
        List<dynamic> messages = data["formattedMessages"];

        for (var msgData in messages) {
          if (msgData is Map<String, dynamic>) {
            final message = Message.fromJson(msgData);
            // Check if the message already exists in the list based on its ID
            if (!_currentChatMessages.any((msg) => msg.id == message.id)) {
              _currentChatMessages.add(message);
            }
          }
        }

        notifyListeners(); // Notify UI to update
      } else {
        print("Error: formattedMessages is not a list or data is null.");
      }
    });

    // Listener for the "receiveMessage" event
    _socket!.on("receiveMessage", (data) {
      print(" message from 'message' event: $data");
      _currentChatName = data[0]["conversation_id"];

      if (data is List) {
        for (var item in data) {
          final message = Message.fromJson(item);
          // Check if the message already exists in the list based on its ID
          if (!_currentChatMessages.any((msg) => msg.id == message.id)) {
            _currentChatMessages.add(message);
          }
        }
      } else if (data is Map<String, dynamic>) {
        final message = Message.fromJson(data);
        // Check if the message already exists in the list based on its ID
        if (!_currentChatMessages.any((msg) => msg.id == message.id)) {
          _currentChatMessages.add(message);
        }
      } else {
        print("Unknown data format: $data");
      }

      notifyListeners(); // Notify listeners to update the UI
    });

    // Listener for the "message" event
    _socket!.on("message", (data) {
      print(" message from 'message' event: $data");
      _currentChatName = data[0]["conversation_id"];

      if (data is List) {
        for (var item in data) {
          final message = Message.fromJson(item);
          // Check if the message already exists in the list based on its ID
          if (!_currentChatMessages.any((msg) => msg.id == message.id)) {
            _currentChatMessages.add(message);
          }
        }
      } else if (data is Map<String, dynamic>) {
        final message = Message.fromJson(data);
        // Check if the message already exists in the list based on its ID
        if (!_currentChatMessages.any((msg) => msg.id == message.id)) {
          _currentChatMessages.add(message);
        }
      } else {
        print("Unknown data format: $data");
      }

      notifyListeners(); // Notify listeners to update the UI
    });

    // Handle socket errors
    _socket!.on(Constants.error, (data) {
      print("Socket Error: $data");
      _handleSocketError(data);
    });

    // Handle connection errors
    _socket!.onConnectError((data) {
      print("Socket connection error: $data");
      _handleSocketError(data);
    });

    // Handle disconnection events
    _socket!.onDisconnect((_) {
      print("Socket disconnected from chat: $_currentChatName");
    });
  }

  // Disconnect from the current chat
  void disconnectFromChat() {
    if (_socket != null) {
      // Emit an event to leave the chat room
      _socket!.emit(Constants.archiveChat, {'chatName': _currentChatName});

      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
      _currentChatName = null;
      notifyListeners();
      print("-==-=-= Socket disconnected");
    }
  }

  // Handle socket errors
  void _handleSocketError(dynamic data) {
    print("Socket Error: $data");
    // Implement additional error handling as needed
  }

  void addLocalMessage(Message message) {
    _currentChatMessages.add(message);
    notifyListeners(); // This will trigger a rebuild of the UI to show the new message
  }

  // Send a text message
  void sendMessage(String userId, String conversationId, String message) {
    if (_socket != null) {
      final messageData = {
        'user_id': userId,
        'conversation_id': conversationId,
        'text': message,
      };

      print("Sending message: $messageData");

      // Emit the message data to the server
      _socket!.emit("sendMessage", messageData);

      // Add the sent message to the local chat messages
      final localMessage = Message(
        senderId: userId,
        content: message,
        conversationId: conversationId,
        msgType: null,
        id: '',
        fileUrl: '',
        createdAt: null,
      );
      _currentChatMessages.add(localMessage);
      notifyListeners(); // Notify listeners to update UI
    } else {
      print("Cannot send message. Socket is null.");
    }
  }
   Future<void> clearChat(String id) async {
    // _profileloading = Status.Loading; // Set to Loading at the start
    // notifyListeners();
print("ia ma here");
    try {
      final response = await ApiRepository.sendDeleteRequest(
        Constants.port,
        "chat/clear-chat/$id",
        authtokken,
      );

      print("Chat API Response: $response");

      if (response['success'] != true) {
        // _profileloading = Status.Failure2;
        // _chatErrorMsg = response['message'];
        notifyListeners();
        // print("Failed to fetch chats: $_chatErrorMsg");
        // return false;
      } else {
        // _allChat = ConversationResponse.fromJson(response);
        // _profileloading = Status.Loaded; // Set to Loaded on success
        notifyListeners();
        print("Successfully fetched chats.");
        // return true;
      }
    } catch (e) {
      // _profileloading = Status.Failure2;
      // _chatErrorMsg = "An error occurred while fetching chats: $e";
      // notifyListeners();
      // print("Error fetching chats: $_chatErrorMsg");
      // return fal/se;
    }
  }


  void getConversationtChat(Map<String, dynamic> chat) {
    if (_currentChatName != null) {
      print("Fetching conversation details for chat: $_currentChatName");
      setLoadingState(LoadingState.loading);
      _socket!.emit("getConversationDetail", chat);
    }
  }

  // Start a new chat
  void startChat(Map<String, dynamic> chat) {
    print("Starting new chat with data: $chat");
    _socket!.emit("startChat", chat);
    _currentChatName = chat['chatName'];

    final localMessage = Message(
      senderId: chat["user_id"],
      content: chat["text"],
      conversationId: '',
      msgType: null,
      id: '',
      fileUrl: '',
      createdAt: null,
    );
    _currentChatMessages.add(localMessage);
    notifyListeners(); // Notify listeners for UI update
  }

  @override
  void dispose() {
    disconnectFromChat();
    super.dispose();
  }
}
