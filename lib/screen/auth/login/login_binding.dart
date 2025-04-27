// import 'package:get/get.dart';
// import 'package:sparkd/pages/auth/login/login_controller.dart';

// import '../../payment/payment_plan/payment_plan_controller.dart';
// import '../../settings/inapp_purchase_source.dart';

// class LoginBinding extends Bindings {
//   @override
//   void dependencies() {

//     Get.lazyPut<InAppPurchaseSource>(
//           () => InAppPurchaseSourceImpl(),
//       fenix: true,
//     );

//     Get.lazyPut<PaymentPlanController>(
//           () => PaymentPlanController(inAppPurchaseSource: Get.find<InAppPurchaseSource>()),
//       fenix: true,
//     );

//     Get.lazyPut<LoginController>(
//       () => LoginController(),
//     );
//   }
// }
