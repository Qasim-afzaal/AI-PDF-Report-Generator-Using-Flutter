// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'signup_controller.dart';

// class OtpScreen extends StatefulWidget {
//   @override
//   _OtpScreenState createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   TextEditingController _otpController = TextEditingController();
//   SignupController signupController = Get.find<SignupController>();
//   bool _isOtpFilled = false; // Track if all fields are filled
//   bool _isResendEnabled = true; // Control resend button state

//   void _onOtpCompleted(String value) {
//     // Do nothing for now; verification is handled via API call
//   }

//   void _onOtpChanged(String value) {
//     setState(() {
//       // Enable the button only if all 4 fields are filled
//       _isOtpFilled = value.length == 4;
//     });
//   }

//   Future<void> _resendOtp() async {
//     setState(() {
//       _isResendEnabled = false; // Disable button temporarily
//     });

//     await signupController.emailVerification(); // Add your resend OTP logic here

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("OTP has been resent")),
//     );

//     // Re-enable the resend button after a delay (e.g., 30 seconds)
//     Future.delayed(Duration(seconds: 30), () {
//       setState(() {
//         _isResendEnabled = true;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("OTP Verification"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Enter the 4-digit OTP",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             PinCodeTextField(
//               controller: _otpController,
//               appContext: context,
//               length: 4,
//               obscureText: false,
//               onCompleted: _onOtpCompleted,
//               onChanged: _onOtpChanged, // Update the button state on every change
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isOtpFilled
//                   ? signupController.codeVerification // Enable if OTP is filled
//                   : null, // Disable the button if not filled
//               child: Text("Verify OTP"),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "The code in the email will only be valid for 10 minutes.\nBe sure to also check your spam folder.",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: _isResendEnabled ? _resendOtp : null, // Disable if not allowed
//               child: Text(
//                 _isResendEnabled ? "Resend OTP" : "Resend in 30 seconds", // Update text dynamically
//                 style: TextStyle(
//                   color: _isResendEnabled ? Colors.blue : Colors.grey,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
