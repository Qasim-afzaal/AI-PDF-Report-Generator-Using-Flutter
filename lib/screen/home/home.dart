import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradelinkedai/core/components/app_button.dart';
import 'package:tradelinkedai/core/providers/auth.dart';
import 'package:tradelinkedai/core/providers/main_provider.dart';
import 'package:tradelinkedai/screen/chat/chat_screen.dart';
import 'package:tradelinkedai/widget/appbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _chatNameController = TextEditingController();

  void _showAddChatNameBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Create Chat',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Enter chat name to create chat",
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _chatNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Chat Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      return AppButton.primary(
                        title: "Create Chat",
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          chatProvider.currentChatMessages.clear();
                          final chatName = _chatNameController.text.trim();
                          if (chatName.isNotEmpty) {
                            final chayProvider = Provider.of<ChatProvider>(
                                context, listen: false);
                            chayProvider.storebool(true);
                            Navigator.pop(context);
                            final authProvider = Provider.of<AuthProvider>(
                                context, listen: false);
                            final userId = authProvider.user?.data.id;
                            final username = authProvider.user?.data.name;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        userId: userId!,
                                        userName: username!,
                                        chatName: _chatNameController.text,
                                        conversationId: '',
                                        chatnRoom: _chatNameController.text,
                                        boolnewchat: true,
                                      )),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a chat name.'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getallChat();
      fetchusername();
    });
  }
  String name="";
fetchusername(){
   final chatProvider = Provider.of<AuthProvider>(context, listen: false);
    name = chatProvider.user!.data.name!;
    setState(() {
      
    });
}
  Future<void> getallChat() async {
    final chatProvider = Provider.of<AuthProvider>(context, listen: false);
    await chatProvider.getAllChat();
    _chatNameController.clear();
  }

  @override
  void dispose() {
    Provider.of<ChatProvider>(context, listen: false).disconnectFromChat();
    _chatNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<AuthProvider>(context);
    final chatNames = chatProvider.allChat;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:  CustomAppBar(
        title: "Hello ${name??""}",
        showLogoutIcon: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddChatNameBottomSheet,
        child: const Icon(Icons.add),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          Status currentStatus = authProvider.profileloading;

          if (currentStatus == Status.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (currentStatus == Status.Failure2) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  authProvider.chatErrorMsg,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (authProvider.allChat == null ||
              authProvider.allChat!.data.isEmpty) {
            return RefreshIndicator(
              onRefresh: getallChat, // Reload data on swipe down
              child: ListView(
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No chats available. Click the + button to add a new chat.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: getallChat, // Reload data on swipe down
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: chatNames!.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        chatNames.data[index].conversationName ?? "",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        final userId = authProvider.user?.data.id;
                        final username = authProvider.user?.data.name;
                        final chatname = _chatNameController.text;
                        final chatprovider =
                            Provider.of<ChatProvider>(context, listen: false);
                        chatprovider.storebool(false);
                        chatprovider.currentChatName =
                            chatProvider.allChat!.data[index].conversationId;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    userId: userId!,
                                    userName: username!,
                                    chatName: chatname,
                                    conversationId:
                                        chatprovider.currentChatName!,
                                    boolnewchat: false,
                                    chatnRoom: chatProvider
                                        .allChat!.data[index].conversationName!,
                                  )),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
