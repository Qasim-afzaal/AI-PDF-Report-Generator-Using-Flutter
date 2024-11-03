import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradelinkedai/core/providers/auth.dart';
import 'package:tradelinkedai/widget/appbar.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {


  void _showQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Survey Details'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '''You're report conducting assistant. Ask required questions and after user answer all questions create JSON with questions and answers set. It must be a list of dicts like:
{
  "report": "done",
  "data": [{"Q1": "Question", "A1": "Answer"}, ...]
}
If it's in progress, the response will be like:
{
  "report": "in progress",
  "data": "" // AI response according to user question.
}
Every response must be in JSON format. 
Keep the chat experience professional. When the user provides answers, maintain the survey and proceed with proper questions in sequence. If the user says 'finish it,' skip all questions and go to the last question.''',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getallChat();
    });
  }

  Future<void> getallChat() async {
    final chatProvider = Provider.of<AuthProvider>(context, listen: false);
    await chatProvider.getAllUsers();
  }
    Future<void> allListt() async {
    final chatProvider = Provider.of<AuthProvider>(context, listen: false);
    await chatProvider.handleState(Status.UsersScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: "Hello Admin",
        showLogoutIcon: true,
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
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      allListt();
                    },
                    child: const Text('Total Users'),
                  ),
                  GestureDetector(
                    onTap: () {
                      allListt();
                    },
                    child: SizedBox(
                      height: 300,
                      child: _buildGridView(context, 1, showButtons: false),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dataset Files'),
                            SizedBox(
                              height: 200,
                              child: CustomCard(showButtons: true),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Question File'),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                // _showQuestionDialog(context);
                              },
                              child: const SizedBox(
                                height: 200,
                                child: CustomCard(showButtons: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          // Add a fallback widget here
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}

Widget _buildGridView(BuildContext context, int itemCount,
    {required bool showButtons}) {
  return GridView.builder(
    padding: const EdgeInsets.all(8.0), // Reduced padding inside the GridView
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 2 columns
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1.0, // Adjust aspect ratio as needed
    ),
    itemCount: itemCount,
    itemBuilder: (context, index) {
      return FolderRequestCard(
        index: index,
        showButtons: showButtons,
      );
    },
  );
}

class FolderRequestCard extends StatelessWidget {
  final int index;
  final bool showButtons;

  const FolderRequestCard({
    required this.index,
    required this.showButtons,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return Card(
      elevation: 2.0, // Reduced elevation
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding inside the card
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!showButtons)
              Text(
                chatProvider.getCount,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontSize: 14), // Smaller font size
              )
            else ...[
              const Icon(
                Icons.picture_as_pdf,
                size: 30.0, // Reduced size
                color: Colors.red,
              ),
              Text(
                index == 0 ? 'Documents 2' : 'question files',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontSize: 14), // Smaller font size
              ),
              const SizedBox(
                  height: 4.0), // Reduced space between text and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle view action
                    },
                    child: const Text('View',
                        style: TextStyle(fontSize: 12)), // Smaller font size
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle replace action
                    },
                    child: const Text('Replace',
                        style: TextStyle(fontSize: 12)), // Smaller font size
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final bool showButtons;

  const CustomCard({Key? key, required this.showButtons}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showButtons) ...[
            const Icon(Icons.picture_as_pdf, size: 30.0, color: Colors.red),
            Text(
              'Documents 2',
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _showQuestionDialog(context);
                    // Handle view action
                  },
                  child: const Text('View', style: TextStyle(fontSize: 12)),
                ),
                TextButton(
                  onPressed: () {
                    _showQuestionDialog(context);
                    // Handle replace action
                  },
                  child: const Text('Replace', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Survey Details'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '''You're report conducting assistant. Ask required questions and after user answer all questions create JSON with questions and answers set. It must be a list of dicts like:
{
  "report": "done",
  "data": [{"Q1": "Question", "A1": "Answer"}, ...]
}
If it's in progress, the response will be like:
{
  "report": "in progress",
  "data": "" // AI response according to user question.
}
Every response must be in JSON format. 
Keep the chat experience professional. When the user provides answers, maintain the survey and proceed with proper questions in sequence. If the user says 'finish it,' skip all questions and go to the last question.''',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
