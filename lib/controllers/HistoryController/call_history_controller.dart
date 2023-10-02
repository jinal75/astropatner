import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/models/History/call_history_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:get/get.dart';

class CallHistoryController extends GetxController {
  String screen = 'call_history_controller.dart';
  APIHelper apiHelper = APIHelper();
  List<CallHistoryModel> callHistoryList = [];
  SignupController signupController = Get.find<SignupController>();

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    signupController.astrologerProfileById(false);
  }
}
