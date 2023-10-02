import 'package:astrologer_app/controllers/app_review_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../../../constants/colorConst.dart';
import '../../../../widgets/app_bar_widget.dart';

class AppReviewScreen extends StatelessWidget {
  AppReviewScreen({super.key});
  final AppReviewController appReviewController = Get.find<AppReviewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title: const Text("App Review").translate(),
          actions: [
            IconButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("App Review").translate(),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    titlePadding: const EdgeInsets.all(8),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    content: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'I am the Product Manager',
                            style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                          ).translate(),
                          const Text(
                            'share your feedback to help us improve the app',
                            style: TextStyle(fontSize: 10),
                          ).translate(),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                              future: global.translatedText("Start typing here.."),
                              builder: (context, snapshot) {
                                return TextFormField(
                                  controller: appReviewController.feedbackController,
                                  maxLines: 8,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(5),
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: snapshot.data ?? 'Start typing here..',
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                );
                              }),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 5),
                              child: SizedBox(
                                height: 35,
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                                    fixedSize: MaterialStateProperty.all(Size.fromWidth(Get.width / 2)),
                                    backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (appReviewController.feedbackController.text == "") {
                                      global.showToast(message: 'Please enter feedback');
                                    } else {
                                      global.showOnlyLoaderDialog();
                                      await appReviewController.addFeedback(appReviewController.feedbackController.text);
                                      global.hideLoader();
                                      Get.back();
                                    }
                                  },
                                  child: Text(
                                    'Send Feedback',
                                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                                  ).translate(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: GetBuilder<AppReviewController>(builder: (appReviewController) {
          return appReviewController.clientReviews.isEmpty
              ? Center(child: const Text('App reviews not added yet!').translate())
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                      itemCount: appReviewController.clientReviews.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 4, right: 4, top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  appReviewController.clientReviews[index].profile == ""
                                      ? Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            color: Get.theme.primaryColor,
                                            image: const DecorationImage(
                                              image: AssetImage("assets/images/no_customer_image.png"),
                                            ),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: '${global.imgBaseurl}${appReviewController.clientReviews[index].profile}',
                                          imageBuilder: (context, imageProvider) => Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: Get.theme.primaryColor,
                                              image: DecorationImage(
                                                image: NetworkImage("${global.imgBaseurl}${appReviewController.clientReviews[index].profile}"),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: Get.theme.primaryColor,
                                              image: const DecorationImage(
                                                image: AssetImage("assets/images/no_customer_image.png"),
                                              ),
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            // ignore: unnecessary_null_comparison
                                            (appReviewController.clientReviews[index].name != null && appReviewController.clientReviews[index].name != '') ? appReviewController.clientReviews[index].name : 'User',
                                            style: Get.theme.primaryTextTheme.subtitle2!.copyWith(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ).translate(),
                                        ),
                                        Text(
                                          appReviewController.clientReviews[index].location,
                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ).translate(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  appReviewController.clientReviews[index].review,
                                  maxLines: 6,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  style: Get.theme.primaryTextTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ).translate(),
                              ),
                            ],
                          ),
                        );
                      }),
                );
        }),
      ),
    );
  }
}
