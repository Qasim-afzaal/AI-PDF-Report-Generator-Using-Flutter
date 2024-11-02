// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sparkd/api_repository/api_class.dart';
// import 'package:sparkd/api_repository/api_function.dart';
// import 'package:sparkd/core/constants/app_strings.dart';
// import 'package:sparkd/core/constants/constants.dart';
// import 'package:sparkd/pages/auth/login/login_controller.dart';
// import 'package:sparkd/pages/auth/login/login_response.dart';
// import 'package:sparkd/pages/payment/payment_plan/payment_plan_controller.dart';
// import 'package:sparkd/routes/app_pages.dart';
// import 'package:the_apple_sign_in/the_apple_sign_in.dart';

// import '../../../main.dart';
// import '../../../models/error_response.dart';

// class SignupController extends GetxController {
//   String? gender;
//   String? ageRange;
//   RxString otp = "".obs;
//   String? personalityType;
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController otpController = TextEditingController();
//   final PaymentPlanController _paymentPlanController =
//       getPaymentPlanController();

//   void handleNavigation() {
//     _paymentPlanController.isUserSubscribedToProduct((p0) {
//       if (p0 == true) {
//         Get.offNamed(Routes.DASHBOARD);
//       } else {
//         Get.offNamed(Routes.PAYMENT_PLAN);
//       }
//     });
//   }

//   @override
//   void onInit() {
//     if (Get.arguments != null) {
//       gender = Get.arguments[HttpUtil.gender].toString();
//       ageRange = Get.arguments[HttpUtil.age].toString();
//       personalityType = Get.arguments[HttpUtil.personalityType].toString();
//     }
//     super.onInit();
//   }

//   void onLogin() {
//     Get.offNamed(Routes.LOGIN);
//   }

//   Future<void> onSignup() async {
//     if (isSignUpValidation()) {
//       var json = {
//         HttpUtil.name: userNameController.text.trim(),
//         HttpUtil.authProvider: "",
//         HttpUtil.email: emailController.text.trim(),
//         HttpUtil.password: passwordController.text.trim(),
//         HttpUtil.gender: gender,
//         HttpUtil.age: ageRange,
//         HttpUtil.personalityType: personalityType,
//         HttpUtil.profileImageUrl: "",
//       };
//       final data = await APIFunction().apiCall(
//         apiName: Constants.signUp,
//         withOutFormData: jsonEncode(json),
//       );
//       try {
//         LoginResponse mainModel = LoginResponse.fromJson(data);
//         if (mainModel.success!) {
//           getStorageData.saveLoginData(mainModel);
//           handleNavigation();
//         } else {
//           utils.showToast(message: mainModel.message!);
//         }
//       } catch (e) {
//         ErrorResponse errorModel = ErrorResponse.fromJson(data);
//         utils.showToast(message: errorModel.message!);
//       }
//     }
//   }

//   Future<void> emailVerification() async {
//     if (isEmailValidation()) {
//       var json = {
//         HttpUtil.email: emailController.text.trim(),
//       };
//       final data = await APIFunction().apiCall(
//         apiName: Constants.sendOTPforEmail,
//         withOutFormData: jsonEncode(json),
//       );
//       try {
//         LoginResponse mainModel = LoginResponse.fromJson(data);
//         if (mainModel.success!) {
//           Get.offNamed(Routes.OTP_SIGNIN, arguments: {
//             HttpUtil.name: userNameController.text.trim(),
//             HttpUtil.authProvider: "",
//             HttpUtil.email: emailController.text.trim(),
//             HttpUtil.password: passwordController.text.trim(),
//             HttpUtil.gender: gender,
//             HttpUtil.age: ageRange,
//             HttpUtil.personalityType: personalityType,
//             HttpUtil.profileImageUrl: "",
//           });
//         } else {
//           utils.showToast(message: mainModel.message!);
//         }
//       } catch (e) {
//         ErrorResponse errorModel = ErrorResponse.fromJson(data);
//         utils.showToast(message: errorModel.message!);
//       }
//     }
//   }
//   Future<void> emailVerifi() async {
//     if (isSignUpValidation()) {
//       var json = {
//         HttpUtil.email: emailController.text.trim(),
//       };
//       print("this is request body$json");
//       final data = await APIFunction().apiCall(
//         apiName: Constants.sendOTP,
//         withOutFormData: jsonEncode(json),
//       );
//       try {
//         LoginResponse mainModel = LoginResponse.fromJson(data);
//         if (mainModel.success!) {
//           utils.showToast(message: "Email already exist");
      
//         } else {
//           emailVerification();
//         }
//       } catch (e) {
//         ErrorResponse errorModel = ErrorResponse.fromJson(data);
//         utils.showToast(message: errorModel.message!);
//       }
//     }
//   }

//   bool isEmailValidation() {
//     utils.hideKeyboard();
//     if (utils.isValidationEmpty(emailController.text)) {
//       utils.showToast(message: AppStrings.errorEmail);
//       return false;
//     } else if (!utils.emailValidator(emailController.text)) {
//       utils.showToast(message: AppStrings.errorValidEmail);
//       return false;
//     }
//     return true;
//   }

//   Future<void> socialSignup(SocialLoginModel socialLoginModel) async {
//     var json = {
//       HttpUtil.name: socialLoginModel.name,
//       HttpUtil.authProvider: socialLoginModel.authProvider,
//       HttpUtil.email: socialLoginModel.emailID,
//       HttpUtil.password: "",
//       HttpUtil.gender: gender,
//       HttpUtil.age: ageRange,
//       HttpUtil.personalityType: personalityType,
//       HttpUtil.profileImageUrl: socialLoginModel.profile_image_url,
//     };
//     final data = await APIFunction().apiCall(
//       apiName: Constants.signUp,
//       withOutFormData: jsonEncode(json),
//     );
//     try {
//       LoginResponse mainModel = LoginResponse.fromJson(data);
//       if (mainModel.success!) {
//         getStorageData.saveLoginData(mainModel);
//         handleNavigation();
//       } else {
//         utils.showToast(message: mainModel.message!);
//       }
//     } catch (e) {
//       ErrorResponse errorModel = ErrorResponse.fromJson(data);
//       utils.showToast(message: errorModel.message!);
//     }
//   }

//   bool isSignUpValidation() {
//     utils.hideKeyboard();
//     if (utils.isValidationEmpty(userNameController.text)) {
//       utils.showToast(message: AppStrings.errorUsername);
//       return false;
//     } else if (utils.isValidationEmpty(emailController.text)) {
//       utils.showToast(message: AppStrings.errorEmail);
//       return false;
//     } else if (!utils.emailValidator(emailController.text)) {
//       utils.showToast(message: AppStrings.errorValidEmail);
//       return false;
//     } else if (utils.isValidationEmpty(passwordController.text)) {
//       utils.showToast(message: AppStrings.errorEmptyPassword);
//       return false;
//     }
//     return true;
//   }

//   GoogleSignInAccount? _currentUser;
//   RxString appleId = "".obs;
//   RxString userName = "".obs;
//   RxString userEmail = "".obs;
//   final GoogleSignIn? googleSignIn = GoogleSignIn();

//   Future<UserCredential?> loginWithGoogle(BuildContext context) async {
//     try {
//       GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//       if (googleUser != null) {
//         _currentUser = googleUser;
//         SocialLoginModel socialLoginModel = SocialLoginModel(
//           emailID: _currentUser!.email,
//           name: _currentUser!.displayName ?? "",
//           authProvider: "GOOGLE",
//           profile_image_url: _currentUser!.photoUrl ?? "",
//         );
//         await socialSignup(socialLoginModel);
//         update();
//       } else {
//         // User canceled the login, show a dialog or a Snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Google Sign-In was cancelled by the user")),
//         );
//       }

//       if (_currentUser != null) {
//         await GoogleSignIn().signOut();
//       }
//     } catch (e) {
//       print("Google Sign-In failed: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Google Sign-In failed: $e")),
//       );
//       return null;
//     }
//     return null;
//   }

//   Future<String> signInWithApple(BuildContext context) async {
//     try {
//       final AuthorizationResult result = await TheAppleSignIn.performRequests([
//         const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
//       ]);

//       switch (result.status) {
//         case AuthorizationStatus.authorized:
//           if (result.credential != null) {
//             userName.value =
//                 "${result.credential!.fullName?.familyName ?? ""} ${result.credential!.fullName?.givenName ?? ""}";
//             appleId.value = result.credential!.user ?? "";
//             userEmail.value = result.credential!.email ?? "";

//             SocialLoginModel socialLoginModel = SocialLoginModel(
//               emailID: userEmail.value,
//               name: userName.value,
//               authProvider: "APPLE",
//               profile_image_url: "", // Update with appropriate value
//             );
//             await socialSignup(socialLoginModel);
//           }
//           break;

//         case AuthorizationStatus.error:
//           print("Sign in failed: ${result.error!.localizedDescription}");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(
//                     "Apple Sign-In failed: ${result.error!.localizedDescription}")),
//           );
//           break;

//         case AuthorizationStatus.cancelled:
//           print('User cancelled');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Apple Sign-In was cancelled by the user")),
//           );
//           break;
//       }
//     } catch (e) {
//       print("Apple Sign-In failed: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Apple Sign-In failed: $e")),
//       );
//     }

//     return "";
//   }
// }
