import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradelinkedai/core/providers/auth.dart';
import 'package:dio/dio.dart'; // For downloading PDF
import 'package:path_provider/path_provider.dart'; // For storing PDF locally
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For PDF viewing
import 'package:tradelinkedai/widget/appbar.dart'; // Assuming this is your custom app bar

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? _pdfPath; // To store the local path of the downloaded PDF

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllUsers();
    });
  }

  Future<void> _getAllUsers() async {
    final chatProvider = Provider.of<AuthProvider>(context, listen: false);
    await chatProvider.getAllPdfList();
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

  _onLogin() {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    auth.handleState(Status.LoggedInAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "User List",
        showLogoutIcon: false,
        centerTitle: true,
        onBackPressed: () {
          _onLogin();
        },
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.profileloading == Status.Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authProvider.getAllList == null ||
              authProvider.getAllList!.data.isEmpty) {
            return const Center(child: Text('No users available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: authProvider.getAllList!.data.length,
              itemBuilder: (context, index) {
                final userFile = authProvider.getAllList!.data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        userFile.name[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      userFile.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      onPressed: () async {
                        await _downloadPdf(userFile.fileUrl);
                        if (_pdfPath != null) {
                          _showPdfPreviewDialog(context);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
