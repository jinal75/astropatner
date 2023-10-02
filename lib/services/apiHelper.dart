//flutter
// ignore_for_file: file_names, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
//models
import 'package:astrologer_app/models/Master%20Table%20Model/get_master_table_list_model.dart';
import 'package:astrologer_app/models/Notification/notification_model.dart';
import 'package:astrologer_app/models/app_review_model.dart';
import 'package:astrologer_app/models/astrologerAssistant_model.dart';
import 'package:astrologer_app/models/call_model.dart';
import 'package:astrologer_app/models/chat_model.dart';
import 'package:astrologer_app/models/customerReview_model.dart';
import 'package:astrologer_app/models/device_detail_model.dart';
import 'package:astrologer_app/models/following_model.dart';
import 'package:astrologer_app/models/hororScopeSignModel.dart';
import 'package:astrologer_app/models/kundliBasicModel.dart';
import 'package:astrologer_app/models/kundliModel.dart';
import 'package:astrologer_app/models/product_category_list_model.dart';
import 'package:astrologer_app/models/product_model.dart';
import 'package:astrologer_app/models/report_model.dart';
import 'package:astrologer_app/models/systemFlagModel.dart';
import 'package:astrologer_app/models/user_model.dart';
import 'package:astrologer_app/models/wallet_model.dart';
import 'package:astrologer_app/services/apiResult.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:http/http.dart' as http;

import '../models/assistant_chat_request_model.dart';
import '../models/astrology_blog_model.dart';
import '../models/intake_model.dart';
import '../models/language.dart';
import '../models/live_users_model.dart';
import '../models/wait_list_model.dart';

//packages

String screen = 'apiHelper.dart';

class APIHelper {
  //bind you api result using it
  dynamic getAPIResult<T>(final response, T recordList) {
    try {
      dynamic result;
      result = APIResult.fromJson(json.decode(response.body), recordList);
      return result;
    } catch (e) {
      print("Exception: $screen - getAPIResult " + e.toString());
    }
  }

  //Signup astrologer
  Future<dynamic> signUp(CurrentUser user) async {
    try {
      print('${global.appParameters[global.appMode]['apiUrl']}astrologer/add');
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}astrologer/add"),
        headers: await global.getApiHeaders(false),
        body: json.encode(user.toJson()),
      );
      log('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = CurrentUser.fromJson(json.decode(response.body)["recordList"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - signUp(): " + e.toString());
    }
  }

  Future<dynamic> validateSession() async {
    try {
      print('${global.appParameters[global.appMode]['apiUrl']}validateSessionForAstrologer');
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}validateSessionForAstrologer"),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(json.decode(response.body)["recordList"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception - validateSession(): " + e.toString());
    }
  }

  Future<dynamic> setRemoteId(int astroId, int remoteId) async {
    try {
      print('${global.appParameters[global.appMode]['apiUrl']}addAstrohost');
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}addAstrohost"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": "$astroId",
          "hostId": "$remoteId",
        }),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - setRemoteId(): " + e.toString());
    }
  }

//Update astrologer
  Future astrologerUpdate(CurrentUser user) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}astrologer/update");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}astrologer/update"),
        headers: await global.getApiHeaders(true),
        body: json.encode(user.toJson()),
      );
      print("Edit profile body ${user.toJson()}");
      log('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = CurrentUser.fromJson(json.decode(response.body)["recordList"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - astrologerUpdate(): " + e.toString());
    }
  }

//Check conatct number is exist
  Future<dynamic> checkExistContactNumber(String contactNo) async {
    try {
      print('${global.appParameters[global.appMode]['apiUrl']}checkContactNoExist');
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}checkContactNoExist"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          'contactNo': contactNo,
        }),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - checkExistContactNumber(): " + e.toString());
    }
  }

//Login api
  Future<dynamic> login(contactNo, DeviceInfoLoginModel userDeviceDetails) async {
    try {
      print('${global.appParameters[global.appMode]['apiUrl']}loginAppAstrologer');
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}loginAppAstrologer"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"contactNo": contactNo, 'userDeviceDetails': userDeviceDetails}),
      );
      print('done : ${json.encode({"contactNo": contactNo, 'userDeviceDetails': userDeviceDetails})}');
      dynamic recordList;

      if (response.statusCode == 200) {
        log('response:- ${response.body}');
        recordList = CurrentUser.fromJson(json.decode(response.body)["recordList"][0]);
        recordList.token = json.decode(response.body)["token"];
        recordList.tokenType = json.decode(response.body)["token_type"];
      } else if (response.statusCode == 400) {
        recordList = json.decode(response.body)["message"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - login(): " + e.toString());
    }
  }

  //Delete astrologer account
  Future<dynamic> astrologerDelete(int id) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}astrologer/delete");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}astrologer/delete"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - astrologerDelete(): " + e.toString());
    }
  }

//Master table
  Future getMasterTableData() async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}getMasterAstrologer");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getMasterAstrologer"),
        headers: await global.getApiHeaders(false),
      );

      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = GetMasterTableDataModel.fromJson(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - getMasterTableData(): " + e.toString());
    }
  }

//-------------------------------- Profile details ---------------------------//

//get profile
  Future<dynamic> getAstrologerProfile(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getAstrologerById"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id, "startIndex": startIndex, "fetchRecord": record}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CurrentUser>.from(json.decode(response.body)["recordList"].map((x) => CurrentUser.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getAstrologerProfile():-' + e.toString());
    }
  }

//--------------------------------Chat ---------------------------//
  //get chat request
  Future<dynamic> getchatRequest(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}chatRequest/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id, "startIndex": startIndex, "fetchRecord": record}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ChatModel>.from(json.decode(response.body)["recordList"].map((x) => ChatModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getchatRequest(): ' + e.toString());
    }
  }

  //get chat reject
  Future<dynamic> chatReject(int chatId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}chatRequest/reject"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"chatId": chatId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - chatReject(): ' + e.toString());
    }
  }

  Future<dynamic> acceptChatRequest(int chatId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}chatRequest/accept"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"chatId": chatId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        //recordList = List<ChatModel>.from(json.decode(response.body)["recordList"].map((x) => ChatModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - acceptChatRequest(): ' + e.toString());
    }
  }

  Future<dynamic> getChatId() async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}chatRequest/accept"),
        headers: await global.getApiHeaders(true),
        //body: {'chatId': '$chatId'},
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        //recordList = List<ChatModel>.from(json.decode(response.body)["recordList"].map((x) => ChatModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getChatId(): ' + e.toString());
    }
  }

  Future<dynamic> addChatId(int userId, int partnerId, int chatId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}chatRequest/storeChatId"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"userId": userId, "partnerId": partnerId, "chatId": chatId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
        //recordList = List<ChatModel>.from(json.decode(response.body)["recordList"].map((x) => ChatModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addChatId(): ' + e.toString());
    }
  }

  Future<dynamic> addChatToken(String token, String channelName, int chatId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}chatRequest/storeToken"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"token": token, "channelName": channelName, "chatId": chatId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addChatToken():-' + e.toString());
    }
  }

//-------------------------- Call --------------------------------------//
  //get call request
  Future<dynamic> getCallRequest(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}callRequest/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id, "startIndex": startIndex, "fetchRecord": record}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CallModel>.from(json.decode(response.body)["recordList"].map((x) => CallModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getCallRequest(): ' + e.toString());
    }
  }

  Future<dynamic> acceptCallRequest(int callId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}callRequest/accept"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"callId": callId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        //recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - acceptCallRequest():-' + e.toString());
    }
  }

  Future<dynamic> rejectCallRequest(int callId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}callRequest/reject"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"callId": callId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - rejectCallRequest():-' + e.toString());
    }
  }

  Future<dynamic> addCallToken(String token, String channelName, int callId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}callRequest/storeToken"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"token": token, "channelName": channelName, "callId": callId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addCallToken():-' + e.toString());
    }
  }

//----------------------------- report ----------------------------------//

  Future<dynamic> getReportRequest(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getUserReport"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id, "startIndex": startIndex, "fetchRecord": record}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReportModel>.from(json.decode(response.body)["recordList"].map((x) => ReportModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getReportRequest():-' + e.toString());
    }
  }

  //Upload a report file
  Future sendReport(int id, String reportFile) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}userreport/add");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}userreport/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id, "reportFile": reportFile}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = ReportModel.fromJson(json.decode(response.body)["recordList"]);
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - sendReport(): " + e.toString());
    }
  }

//----------------------------------------Astromall-----------------------------------//
  Future addAstromallProdcut(ProductModel productModel) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}astromallProduct/add");
      final response = await http.post(Uri.parse("${global.appParameters[global.appMode]['apiUrl']}api/getproductCategory"), headers: await global.getApiHeaders(true), body: json.encode(productModel));
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {}
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - addAstromallProdcut(): " + e.toString());
    }
  }

  Future getproductCategory() async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}getproductCategory");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getproductCategory"),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = List<ProductCategoryListModel>.from(json.decode(response.body)["recordList"].map((x) => ProductCategoryListModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - getproductCategory(): " + e.toString());
    }
  }

//----------------------------------------Astrologer assistant-----------------------------------//

//Add an astrologer assistant
  Future<dynamic> astrologerAssistantAdd(AstrologerAssistantModel assistantmodel) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}astrologerAssistant/add");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}astrologerAssistant/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode(assistantmodel.toJson()),
      );
      print(assistantmodel.toJson());
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = AstrologerAssistantModel.fromJson(json.decode(response.body)["recordList"]);
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - astrologerAssistantAdd(): " + e.toString());
    }
  }

//get astrologer asssistant
  Future<dynamic> getAstrologerAssistant(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getAstrologerAssistant"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerAssistantModel>.from(json.decode(response.body)["recordList"].map((x) => AstrologerAssistantModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getAstrologerAssistant():-' + e.toString());
    }
  }

//Update astrologer assistant
  Future astrologerAssistantUpdate(AstrologerAssistantModel assistantmodel) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}astrologerAssistant/update");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}astrologerAssistant/update"),
        headers: await global.getApiHeaders(true),
        body: json.encode(assistantmodel.toJson()),
      );

      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = AstrologerAssistantModel.fromJson(json.decode(response.body)["recordList"]);
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - astrologerAssistantUpdate(): " + e.toString());
    }
  }

  //get astrologer assistant chat request
  Future getAssistantChatRequest(int astrologerId) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}getAssistantChatRequest");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getAssistantChatRequest"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId}),
      );

      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if (json.decode(response.body)["recordList"] != null) {
          recordList = List<AssistantChatRequestModel>.from(json.decode(response.body)["recordList"].map((x) => AssistantChatRequestModel.fromJson(x)));
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - getAssistantChatRequest(): " + e.toString());
    }
  }

  //Astrologer assistant delete
  Future<dynamic> assistantDelete(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}astrologerAssistant/delete"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - assistantDelete():-' + e.toString());
    }
  }

  Future<dynamic> getHoroscope({int? horoscopeSignId}) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getDailyHoroscope"),
        body: json.encode({"horoscopeSignId": horoscopeSignId}),
        headers: await global.getApiHeaders(true),
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getHoroscope():' + e.toString());
    }
  }

//----------------------------------------astrologer review-----------------------------------//

//get customer review for astrologer
  Future<dynamic> getCustomerReview(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getAstrologerUserReview"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = List<CustomerReviewModel>.from(json.decode(response.body)["recordList"].map((x) => CustomerReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getCustomerReview():-' + e.toString());
    }
  }

  //Reply astrologer review
  Future<dynamic> astrologerReply(int id, String reply) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}userReview/reply");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}userReview/reply"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"reviewId": id, "reply": reply}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - astrologerReply():-' + e.toString());
    }
  }

  //---------------------------------- Live Astrologer --------------------------------

  //send liveAstrologer token

  Future sendLiveAstrologerToken(int astrologerId, String channelName, String token, String chatToken) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}liveAstrologer/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": astrologerId,
          "channelName": channelName,
          "token": token,
        }),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
        log('live token save successfully');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - addAstromallProdcut(): " + e.toString());
    }
  }

  Future<dynamic> getWaitList(String channel) async {
    try {
      final response = await http.post(Uri.parse("${global.appParameters[global.appMode]['apiUrl']}waitlist/get"), body: {
        "channelName": channel,
      });
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<WaitList>.from(json.decode(response.body)["recordList"].map((x) => WaitList.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAstrologer():' + e.toString());
    }
  }

  Future sendLiveAstrologerChatToken(int astrologerId, String channelName, String token) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}liveAstrologer/livechattoken"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId, "channelName": channelName, "liveChatToken": token}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
        log('live chat token save successfully');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - sendLiveAstrologerChatToken(): " + e.toString());
    }
  }

  Future endLiveSession(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}liveAstrologer/endSession"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - endLiveSession(): " + e.toString());
    }
  }

  //-------------------------------Follower---------------------------------//
  Future<dynamic> getFollowersList(int id, int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getAstrologerFollower"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id, "startIndex": startIndex, "fetchRecord": record}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = List<FollowingModel>.from(json.decode(response.body)["recordList"].map((x) => FollowingModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getFollowersList():-' + e.toString());
    }
  }

  //-------------------------------Wallet---------------------------------//
  Future<dynamic> withdrawAdd(int id, double withdrawAmount, String paymentMethod, String upiId, String accountNumber, String ifscCode, String accountHolderName) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}withdrawlrequest/add");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}withdrawlrequest/add"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": id,
          "withdrawAmount": withdrawAmount,
          "paymentMethod": paymentMethod,
          "upiId": upiId,
          "accountHolderName": accountHolderName,
          "accountNumber": accountNumber,
          "ifscCode": ifscCode,
        }),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - withdrawAdd(): " + e.toString());
    }
  }

  //update withdraw
  Future<dynamic> withdrawUpdate(int id, int astrologerId, double withdrawAmount, String paymentMethod, String upiId, String accountNumber, String ifscCode, String accountHolderName) async {
    try {
      print("${global.appParameters[global.appMode]['apiUrl']}withdrawlrequest/update");
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}withdrawlrequest/update"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "id": id,
          "astrologerId": astrologerId,
          "withdrawAmount": withdrawAmount,
          "paymentMethod": paymentMethod,
          "upiId": upiId,
          "accountHolderName": accountHolderName,
          "accountNumber": accountNumber,
          "ifscCode": ifscCode,
        }),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: $screen - withdrawUpdate(): " + e.toString());
    }
  }

  //get amount
  Future<dynamic> getWithdrawAmount(int id) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}withdrawlrequest/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = Withdraw.fromJson(json.decode(response.body)["recordList"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getWithdrawAmount():-' + e.toString());
    }
  }

  //-------------------------------Notification---------------------------------//
  Future<dynamic> getNotification(int startIndex, int record) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getUserNotification"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"startIndex": startIndex, "fetchRecord": record}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        recordList = List<NotificationModel>.from(json.decode(response.body)["recordList"].map((x) => NotificationModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getNotification():-' + e.toString());
    }
  }

  Future<dynamic> deleteNotification(int notificationId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}userNotification/deleteUserNotification"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": notificationId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - deteNotification():-' + e.toString());
    }
  }

  Future<dynamic> deleteAllNotification(int userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}userNotification/deleteAllNotification"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"userId": userId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - deleteAllNotification():-' + e.toString());
    }
  }

  Future<dynamic> getLiveUsers(String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}getLiveUser'),
        body: json.encode({"channelName": channelName}),
        headers: await global.getApiHeaders(false),
      );
      print('done get live: $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<LiveUserModel>.from(json.decode(response.body)["recordList"].map((x) => LiveUserModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getLiveUsers : -" + e.toString());
    }
  }

  Future<dynamic> addKundli(List<KundliModel> basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}kundali/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"kundali": basicDetails}),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addKundli:- ' + e.toString());
    }
  }

  Future<dynamic> updateKundli(int id, KundliModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}kundali/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in updateKundli:-' + e.toString());
    }
  }

  Future<dynamic> deleteKundli(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}kundali/delete'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in deleteKundli : -" + e.toString());
    }
  }

  Future<dynamic> getKundli() async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getkundali"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<KundliModel>.from(json.decode(response.body)["recordList"].map((x) => KundliModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getSystemFlag() async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getSystemFlag"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<SystemFlag>.from(json.decode(response.body)["recordList"].map((x) => SystemFlag.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - getSystemFlag():-' + e.toString());
    }
  }

  Future<dynamic> addChatWaitList({int? astrologerId, String? status, DateTime? datetime}) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}addStatus"),
        headers: await global.getApiHeaders(true),
        // ignore: prefer_null_aware_operators
        body: json.encode({"astrologerId": astrologerId, "status": status, "waitTime": datetime != null ? datetime.toIso8601String() : null}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addChatWaitList(): ' + e.toString());
    }
  }

  Future<dynamic> addCallWaitList({int? astrologerId, String? status, DateTime? callDateTime}) async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}addCallStatus"),
        headers: await global.getApiHeaders(true),
        // ignore: prefer_null_aware_operators
        body: json.encode({"astrologerId": astrologerId, "status": status, "waitTime": callDateTime != null ? callDateTime.toIso8601String() : null}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: $screen - addCallWaitList(): ' + e.toString());
    }
  }

  //Third Party API

  Future<dynamic> getReport({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/general_ascendant_report"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getReportDasha():' + e.toString());
    }
  }

  Future<dynamic> getHororscopeSign() async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getHororscopeSign"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HororscopeSignModel>.from(json.decode(response.body)["recordList"].map((x) => HororscopeSignModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getHororscopeSign():' + e.toString());
    }
  }

  Future<dynamic> getMatching(
    int? dayBoy,
    int? monthBoy,
    int? yearBoy,
    int? hourBoy,
    int? minBoy,
    int? dayGirl,
    int? monthGirl,
    int? yearGirl,
    int? hourGirl,
    int? minGirl,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/match_ashtakoot_points"),
        body: json.encode({"m_day": dayBoy, "m_month": monthBoy, "m_year": yearBoy, "m_hour": hourBoy, "m_min": minBoy, "m_lat": 19.132, "m_lon": 72.342, "m_tzone": 5.5, "f_day": dayGirl, "f_month": monthGirl, "f_year": yearGirl, "f_hour": hourGirl, "f_min": minGirl, "f_lat": 19.132, "f_lon": 72.342, "f_tzone": 5.5}),
        headers: {
          "authorization":
              // "Basic NjIxNDI5OmQyMTE3M2VmOTk3ZThkNTU5NWEzZWNmNDc2Njk0NGNl",
              "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits),
          "Content-Type": 'application/json'
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
        // recordList = List<KundliMatchingDetailModel>.from(json
        //     .decode(response.body)["recordList"]
        //     .map((x) => KundliMatchingDetailModel.fromJson(x)));
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      print('Exception in getDailyHororscope():' + e.toString());
    }
  }

  Future<dynamic> getManglic(
    int? dayBoy,
    int? monthBoy,
    int? yearBoy,
    int? hourBoy,
    int? minBoy,
    int? dayGirl,
    int? monthGirl,
    int? yearGirl,
    int? hourGirl,
    int? minGirl,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/match_manglik_report"),
        body: json.encode({"m_day": dayBoy, "m_month": monthBoy, "m_year": yearBoy, "m_hour": hourBoy, "m_min": minBoy, "m_lat": 19.132, "m_lon": 72.342, "m_tzone": 5.5, "f_day": dayGirl, "f_month": monthGirl, "f_year": yearGirl, "f_hour": hourGirl, "f_min": minGirl, "f_lat": 19.132, "f_lon": 72.342, "f_tzone": 5.5}),
        headers: {
          "authorization":
              // "Basic NjIxNDI5OmQyMTE3M2VmOTk3ZThkNTU5NWEzZWNmNDc2Njk0NGNl",
              "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits),
          "Content-Type": 'application/json'
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
        // recordList = List<KundliMatchingDetailModel>.from(json
        //     .decode(response.body)["recordList"]
        //     .map((x) => KundliMatchingDetailModel.fromJson(x)));
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      print('Exception in getDailyHororscope():' + e.toString());
    }
  }

  Future<dynamic> getKundliBasicDetails({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/birth_details"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": "application/json"},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKundliBasicDetails():' + e.toString());
    }
  }

  Future<dynamic> getKundliBasicPanchangDetails({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/basic_panchang"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKundliBasicPanchangDetails():' + e.toString());
    }
  }

  Future<dynamic> getAvakhadaDetails({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/astro_details"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAvakhadaDetails():' + e.toString());
    }
  }

  Future<dynamic> getPlanetsDetail({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/planets"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAvakhadaDetails():' + e.toString());
    }
  }

  Future<dynamic> getSadesati({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sadhesati_current_status"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getSadesati():' + e.toString());
    }
  }

  Future<dynamic> getKalsarpa({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/kalsarpa_details"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getKalsarpa():' + e.toString());
    }
  }

  Future<dynamic> getGemstone({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/basic_gem_suggestion"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getGemstone():' + e.toString());
    }
  }

  Future<dynamic> getVimshattari({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/major_vdasha"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getVimshattari():' + e.toString());
    }
  }

  Future<dynamic> getAntardasha({String? antarDasha, int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_vdasha/$antarDasha"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getAntardasha():' + e.toString());
    }
  }

  Future<dynamic> getPatynatarDasha({String? firstName, String? secoundName, int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_sub_vdasha/Mars/Rahu"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getPatynatarDasha():' + e.toString());
    }
  }

  Future<dynamic> getSookshmaDasha({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_sub_sub_vdasha/Mars/Rahu/Jupiter"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getSookshmaDasha():' + e.toString());
    }
  }

  Future<dynamic> getPrana({int? day, int? month, int? year, int? hour, int? min, double? lat, double? lon, double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/sub_sub_sub_sub_vdasha/Mars/Rahu/Jupiter/Saturn"),
        body: json.encode({"day": day, "month": month, "year": year, "hour": hour, "min": min, "lat": lat, "lon": lon, "tzone": tzone}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body) as List).map((e) => VimshattariModel.fromJson(e)).toList();
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      print('Exception in getPrana():' + e.toString());
    }
  }

  Future<dynamic> geoCoding({double? lat, double? long}) async {
    try {
      final response = await http.post(
        Uri.parse('https://json.astrologyapi.com/v1/timezone_with_dst'),
        body: json.encode({"latitude": lat, "longitude": long}),
        headers: {"authorization": "Basic " + base64.encode("${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}".codeUnits), "Content-Type": 'application/json'},
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in geoCoding : -" + e.toString());
    }
  }

  Future<dynamic> generateRtmToken(String agoraAppId, String agoraAppCertificate, String chatId, String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}generateToken'),
        body: json.encode({"appID": agoraAppId, "appCertificate": agoraAppCertificate, "user": chatId, "channelName": channelName}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in generateRtmToken : -" + e.toString());
    }
  }

  Future<dynamic> generateRtcToken(String agoraAppId, String agoraAppCertificate, String chatId, String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}generateRtcToken'),
        body: json.encode({"appID": agoraAppId, "appCertificate": agoraAppCertificate, "user": chatId, "channelName": channelName}),
        headers: await global.getApiHeaders(true),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in generateRtcToken : -" + e.toString());
    }
  }

  //astrology blogs

  Future<dynamic> getBlog(String searchString, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}getAppBlog'),
        headers: await global.getApiHeaders(false),
        body: json.encode({"searchString": searchString, "startIndex": startIndex, "fetchRecord": fetchRecord}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Blog>.from(json.decode(response.body)["recordList"].map((x) => Blog.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getBlog : -" + e.toString());
    }
  }

  Future<dynamic> viewerCount(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}addBlogReader'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"blogId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in viewerCount ' + e.toString());
    }
  }

//get app review
  Future<dynamic> getAppReview() async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}appReview/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"appId": 2}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AppReviewModel>.from(json.decode(response.body)["recordList"].map((x) => AppReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception in getAppReview():' + e.toString());
    }
  }

  Future<dynamic> addAppFeedback(var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}appReview/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      print(response);
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception:- in addAppFeedback:-' + e.toString());
    }
  }

  Future getLanguagesForMultiLanguage() async {
    try {
      final response = await http.post(
        Uri.parse("${global.appParameters[global.appMode]['apiUrl']}getAppLanguage"),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Language>.from(json.decode(response.body)["recordList"].map((x) => Language.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception: api_helper.dart - getLanguagesForMultiLanguage(): " + e.toString());
    }
  }

  //get called user data

  Future<dynamic> getIntakedata(int id) async {
    try {
      final response = await http.post(
        Uri.parse('${global.appParameters[global.appMode]['apiUrl']}chatRequest/getIntakeForm'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"userId": "$id"}),
      );
      print('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<IntakeModel>.from(json.decode(response.body)["recordList"].map((x) => IntakeModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print("Exception in getIntakedata : -" + e.toString());
    }
  }
}
