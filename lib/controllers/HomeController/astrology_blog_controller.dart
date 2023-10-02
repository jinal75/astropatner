// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../models/astrology_blog_model.dart';
import '../../services/apiHelper.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class AstrologyBlogController extends GetxController {
  APIHelper apiHelper = APIHelper();
  final TextEditingController searchTextController = TextEditingController();
  var astrologyBlogs = <Blog>[];
  var astrologySearchBlogs = <Blog>[];
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  int startIndexForSearch = 0;
  bool isDataLoadedForSearch = false;
  bool isAllDataLoadedForSearch = false;
  bool isMoreDataAvailableForSearch = false;
  String? searchString;
  ScrollController blogSearchScrollController = ScrollController();
  ScrollController blogScrollController = ScrollController();
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    paginateTask();
  }

  blogVideo(String link) {
    videoPlayerController = VideoPlayerController.network(
      '${global.imgBaseurl}$link',
    )..initialize().then((_) {
        videoPlayerController!.pause();
        videoPlayerController!.setLooping(true);
        update();
      });
  }

  void blogplayPauseVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
      update();
    } else {
      controller.play();
      update();
    }
  }

  void paginateTask() {
    blogScrollController.addListener(() async {
      if (blogScrollController.position.pixels == blogScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        await getAstrologyBlog("", true);
      }
      update();
    });
    blogSearchScrollController.addListener(() async {
      if (blogSearchScrollController.position.pixels == blogSearchScrollController.position.maxScrollExtent && !isAllDataLoadedForSearch) {
        isMoreDataAvailableForSearch = true;
        if (searchString != null) {
          await getAstrologyBlog(searchString!, true);
        }
      }
      update();
    });
  }

  getAstrologyBlog(String searchString, bool isLazyLoading) async {
    try {
      if (searchString == "") {
        startIndex = 0;
        if (astrologyBlogs.isNotEmpty) {
          startIndex = astrologyBlogs.length;
        }
        if (!isLazyLoading) {
          isDataLoaded = false;
        }
      } else {
        startIndexForSearch = 0;
        if (astrologySearchBlogs.isNotEmpty) {
          startIndexForSearch = astrologySearchBlogs.length;
        }
        if (!isLazyLoading) {
          isDataLoadedForSearch = false;
        }
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getBlog(searchString, searchString == "" ? startIndex : startIndexForSearch, fetchRecord).then((result) {
            if (result.status == "200") {
              if (searchString == "") {
                astrologyBlogs.addAll(result.recordList);
                if (result.recordList.length == 0) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
                update();
              } else {
                astrologySearchBlogs.addAll(result.recordList);
                if (result.recordList.length == 0) {
                  isMoreDataAvailableForSearch = false;
                  isAllDataLoadedForSearch = true;
                }
                update();
              }
            } else {
              global.showToast(message: 'Failed to get Astrology Blog');
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getAstrologyBlog:- $e');
    }
  }

  incrementBlogViewer(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.viewerCount(id).then((result) {
            if (result.status == "200") {
              print('success');
            } else {
              global.showToast(message: 'Faild to increment blog viewer');
            }
          });
        }
      });
    } catch (e) {
      print("Exception in incrementBlogViewer:- $e");
    }
  }
}
