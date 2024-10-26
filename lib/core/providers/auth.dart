import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tradelinkedai/core/constants/app_globals.dart';
import 'package:tradelinkedai/core/constants/constants.dart';
import 'package:tradelinkedai/models/getAllList.dart';
import 'package:tradelinkedai/models/get_all_chat_model.dart';
import 'package:tradelinkedai/models/user_Data_model.dart';
import 'package:tradelinkedai/services/api_repository.dart';
import 'package:tradelinkedai/utils/shared_preference/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedInHome,
  LoggedInAdmin,
  Registered,
  Chat,
  Authenticating,
  profileScreenloading,
  UsersScreen,
  LoggedOut,
  Failure,
  Failure2,
  Loading,
  Loaded,
  SplashPage
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.Authenticating;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  SharedPref _sharedPref = SharedPref();

  String? _googleUserName;

  String? _name;
  String? get name => _name;
  String? _authProbvider;
  String? get authProbvider => _authProbvider;
  String? _email;
  String? get email => _email;

  /// Variable to store the user's name
  String? _googleUserEmail; // Variable to store the user's email

  String? get googleUserName => _googleUserName; // Getter for the user's name
  String? get googleUserEmail =>
      _googleUserEmail; // Getter for the user's email

  late String _loginErrorMsg;
  String get loginErrorMsg => _loginErrorMsg;

  late String _registerErrorMsg;
  String get registerErrorMsg => _registerErrorMsg;

  String _authTokken = "";
  String get authTokken => _authTokken;

  UserDataModel? _user;

  UserDataModel? get user => _user;
    GetAllList? _getAllList;

  GetAllList? get getAllList => _getAllList;

  ConversationResponse? _allChat;

  ConversationResponse? get allChat => _allChat;

  handleState(Status state) {
    print("This is handle group list state $state");
    _loggedInStatus = state;

    notifyListeners();
  }

  Future<bool> register(String username, password, email) async {
    _registeredInStatus = Status.Loading;
    notifyListeners();
    print("Starting registration for user: $username");

    Map<String, dynamic> jsonData = {
      "name": username,
      "password": password,
      "email": email,
      "auth_provider": _authProbvider ?? "",
      "profile_image_url": ""
    };
    print(jsonData);

    try {
      final response = await ApiRepository.sendPostRequest(
          jsonData, Constants.port, Constants.signUp, null);

      print("Response received: $response");

      if (response['success'] != true) {
        _registeredInStatus = Status.Failure;
        _registerErrorMsg = response['message'];
        notifyListeners();
        print("Registration failed: ${_registerErrorMsg}");
        return false;
      } else {
        SharedPref sharedPref = SharedPref();
        sharedPref.save("authUser", response);
        _registeredInStatus = Status.Registered;
        _loggedInStatus = Status.LoggedInHome;
        _authTokken = response["data"]["access_token"];
        authtokken=_authTokken;
        _user = UserDataModel.fromJson(response);
        print("Registration successful for user: $username");
        notifyListeners();
        return true;
      }
    } catch (e) {
      _registeredInStatus = Status.Failure;
      _registerErrorMsg = "An error occurred during registration: $e";
      notifyListeners();
      print("Error during registration: ${_registerErrorMsg}");
      return false;
    }
  }

  Future<bool> login(String email, String password, String authProvider) async {
    _loggedInStatus = Status.Loading;
    notifyListeners();

    Map<String, dynamic> jsonData = {
      "email": email,
      "password": password ?? "",
      "auth_provider": _authProbvider ?? ""
    };
    _email = email;
    print(jsonData);
    try {
      final response = await ApiRepository.sendPostRequest(
          jsonData, Constants.port, Constants.login, null);

      print("This is response of $jsonData login API: $response");

      if (response['success'] != true) {
        _loggedInStatus = Status.Failure;
        _loggedInStatus = Status.Registered;
        _loginErrorMsg = response['message'];
        notifyListeners();
        print("Login failed: ${_loginErrorMsg}");
        return false;
      } else {
        SharedPref sharedPref = SharedPref();
        sharedPref.save("authUser", response);
        _authProbvider = "";
        _email = "";
        _name = "";
        _authTokken = response["data"]["access_token"];
        authtokken=_authTokken;

        if (response["data"]["email"] == "tradelinkadmin@gmail.com") {
          _loggedInStatus = Status.LoggedInAdmin;
        } else {
          _loggedInStatus = Status.LoggedInHome;
        }

        _user = UserDataModel.fromJson(response);
        notifyListeners();
        print("Login successful for user: $email");
        return true;
      }
    } catch (e) {
      _loggedInStatus = Status.Failure;
      _loginErrorMsg = "An error occurred during login: $e";
      notifyListeners();
      print("Error during login: ${_loginErrorMsg}");
      return false; // Return false in case of an exception
    }
  }

  Status _profileloading = Status.profileScreenloading;
  Status get profileloading => _profileloading;

  Status _chatloading = Status.Failure2;
  Status get chatLoading => _chatloading;

  late String _chatErrorMsg;
  String get chatErrorMsg => _chatErrorMsg;

  Future<bool> getAllChat() async {
    _profileloading = Status.Loading; // Set to Loading at the start
    notifyListeners();

    try {
      final response = await ApiRepository.sendGetRequest(
        Constants.port,
        "chat/chat-list/false",
        _authTokken,
      );

      print("Chat API Response: $response");

      if (response['success'] != true) {
        _profileloading = Status.Failure2;
        _chatErrorMsg = response['message'];
        notifyListeners();
        print("Failed to fetch chats: $_chatErrorMsg");
        return false;
      } else {
        _allChat = ConversationResponse.fromJson(response);
        _profileloading = Status.Loaded; // Set to Loaded on success
        notifyListeners();
        print("Successfully fetched chats.");
        return true;
      }
    } catch (e) {
      _profileloading = Status.Failure2;
      _chatErrorMsg = "An error occurred while fetching chats: $e";
      notifyListeners();
      print("Error fetching chats: $_chatErrorMsg");
      return false;
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
        _authTokken,
      );

      print("Chat API Response: $response");

      if (response['success'] != true) {
        // _profileloading = Status.Failure2;
        // _chatErrorMsg = response['message'];
        notifyListeners();
        print("Failed to fetch chats: $_chatErrorMsg");
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
      print("Error fetching chats: $_chatErrorMsg");
      // return fal/se;
    }
  }
   String _getCount="";
  String get getCount => _getCount;
  Future<bool> getAllUsers() async {
    _profileloading = Status.Loading; // Set to Loading at the start
    notifyListeners();

    try {
      final response = await ApiRepository.sendGetRequest(
        Constants.port,
        "users",
        _authTokken,
      );

      print("Users API Response: $response");

      if (response['success'] != true) {
        _profileloading = Status.Failure2;
        _chatErrorMsg = response['message'];
        notifyListeners();
        print("Failed to fetch chats: $_chatErrorMsg");
        return false;
      } else {
      _getCount=response["data"].toString();
        _profileloading = Status.Loaded; // Set to Loaded on success
        notifyListeners();
        print("Successfully fetched chats.");
        return true;
      }
    } catch (e) {
      _profileloading = Status.Failure2;
      _chatErrorMsg = "An error occurred while fetching chats: $e";
      notifyListeners();
      print("Error fetching chats: $_chatErrorMsg");
      return false;
    }
  }

  Future<bool> getAllPdfList() async {
    _profileloading = Status.Loading; // Set to Loading at the start
    notifyListeners();

    try {
      final response = await ApiRepository.sendGetRequest(
        Constants.port,
        "chat/pdf-files-list",
        _authTokken,
      );

      print("Users API Response: $response");

      if (response['success'] != true) {
        _profileloading = Status.Failure2;
        _chatErrorMsg = response['message'];
        notifyListeners();
        print("Failed to fetch chats: $_chatErrorMsg");
        return false;
      } else {
        _getAllList=GetAllList.fromJson(response);
       
        _profileloading = Status.Loaded; // Set to Loaded on success
        notifyListeners();
        print("Successfully fetched chats.");
        return true;
      }
    } catch (e) {
      _profileloading = Status.Failure2;
      _chatErrorMsg = "An error occurred while fetching chats: $e";
      notifyListeners();
      print("Error fetching chats: $_chatErrorMsg");
      return false;
    }
  }

  logout() {
    SharedPref sharedPref = SharedPref();
    sharedPref.remove("authUser");
    _loggedInStatus = Status.LoggedOut;

    notifyListeners();
  }

  isUserLogedIn() async {
    final authUser = await _sharedPref.read("authUser");
    // print(
    //     "this is authUser ${jsonDecode(authUser)["messaging_server_map"]["host"]}");
    // print("this is authUser port ${jsonDecode(authUser)}");
    if (authUser == null) {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    } else {
         final decodedAuthUser = jsonDecode(authUser); 
      print("$authUser");
      if (decodedAuthUser["data"]["email"] == "tradelinkadmin@gmail.com") {
        _loggedInStatus = Status.LoggedInAdmin;
      } else {
        _loggedInStatus = Status.LoggedInHome;
      }

      _user = UserDataModel.fromJson(jsonDecode(authUser));
      _authTokken = _user!.data.accessToken!;
        authtokken=_authTokken;

      notifyListeners();
    }
  }

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        String? name = googleUser.displayName;
        String? email = user.email;
        String? photoUrl = user.photoURL;
        _name = name;
        _email = email;
        _authProbvider = "GOOGLE";
        print("data gere $name...... $email");

        // Store the name and email in the variables
        _googleUserName = name;
        _googleUserEmail = email;

        print('Name: $_googleUserName');
        print('Email: $_googleUserEmail');

        // Call the login API
        bool loginSuccess = await login(email!, "", 'google');
        if (!loginSuccess) {
          print("Login API call failed.");
          return null;
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw 'Signin exception encountered: ${e.message}';
    } catch (e) {
      throw 'Unknown exception encountered: $e';
    }
  }

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
