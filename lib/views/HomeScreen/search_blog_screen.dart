import 'dart:io';

import 'package:astrologer_app/controllers/HomeController/astrology_blog_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../models/astrology_blog_model.dart';
import 'FloatingButton/AstroBlog/astrology_blog_detil_screen.dart';

class SearchBlogScreen extends StatelessWidget {
  SearchBlogScreen({Key? key}) : super(key: key);
  final AstrologyBlogController blogController = Get.find<AstrologyBlogController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              blogController.astrologySearchBlogs = <Blog>[];
              blogController.searchTextController.clear();
              blogController.update();
              Get.back();
            },
            icon: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Get.theme.iconTheme.color,
            ),
          ),
          title: GetBuilder<AstrologyBlogController>(builder: (b) {
            return FutureBuilder(
                future: global.translatedText("Search by Blog Title"),
                builder: (context, snapshot) {
                  return TextField(
                    autofocus: true,
                    onChanged: (value) async {
                      if (value.length > 2) {
                        global.showOnlyLoaderDialog();
                        blogController.searchString = blogController.searchTextController.text;
                        blogController.astrologySearchBlogs = [];
                        blogController.astrologySearchBlogs.clear();
                        blogController.isAllDataLoadedForSearch = false;
                        blogController.update();
                        await blogController.getAstrologyBlog(blogController.searchTextController.text, false);
                        global.hideLoader();
                      }
                    },
                    controller: blogController.searchTextController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: snapshot.data ?? 'Search by Blog Title',
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  );
                });
          }),
          actions: [
            GetBuilder<AstrologyBlogController>(builder: (blogController) {
              return IconButton(
                  onPressed: () async {
                    global.showOnlyLoaderDialog();
                    blogController.searchString = blogController.searchTextController.text;
                    blogController.astrologySearchBlogs = [];
                    blogController.astrologySearchBlogs.clear();
                    blogController.isAllDataLoadedForSearch = false;
                    blogController.update();
                    await blogController.getAstrologyBlog(blogController.searchTextController.text, false);
                    global.hideLoader();
                  },
                  icon: Icon(
                    Icons.search,
                    color: Get.theme.iconTheme.color,
                  ));
            })
          ],
        ),
        body: GetBuilder<AstrologyBlogController>(builder: (blogController) {
          return blogController.astrologySearchBlogs.isEmpty
              ? Center(
                  child: const Text('Blogs not found').translate(),
                )
              : ListView.builder(
                  itemCount: blogController.astrologySearchBlogs.length,
                  controller: blogController.blogSearchScrollController,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () async {
                        global.showOnlyLoaderDialog();
                        await blogController.incrementBlogViewer(blogController.astrologySearchBlogs[index].id);
                        blogController.blogVideo(blogController.astrologyBlogs[index].blogImage);
                        global.hideLoader();
                        Get.to(() => AstrologyBlogDetailScreen(
                              image: blogController.astrologySearchBlogs[index].blogImage,
                              title: blogController.astrologySearchBlogs[index].title,
                              description: blogController.astrologySearchBlogs[index].description ?? "",
                              extension: blogController.astrologyBlogs[index].extension ?? "",
                              videoPlayerController: blogController.videoPlayerController!,
                            ));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                                      child: blogController.astrologySearchBlogs[index].blogImage == ""
                                          ? Image.asset(
                                              "assets/images/2022Image.jpg",
                                              height: 180,
                                              width: MediaQuery.of(context).size.width,
                                              fit: BoxFit.fill,
                                            )
                                          : blogController.astrologyBlogs[index].extension == 'mp4' || blogController.astrologyBlogs[index].extension == 'gif'
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: '${global.imgBaseurl}${blogController.astrologyBlogs[index].previewImage}',
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        height: 180,
                                                        width: Get.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(10),
                                                          image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: imageProvider,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                      errorWidget: (context, url, error) => Image.asset(
                                                        "assets/images/2022Image.jpg",
                                                        height: 180,
                                                        width: Get.width,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.play_arrow,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: '${global.imgBaseurl}${blogController.astrologySearchBlogs[index].blogImage}',
                                                  imageBuilder: (context, imageProvider) => Image.network(
                                                    "${global.imgBaseurl}${blogController.astrologySearchBlogs[index].blogImage}",
                                                    height: 180,
                                                    width: MediaQuery.of(context).size.width,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    "assets/images/2022Image.jpg",
                                                    height: 180,
                                                    width: MediaQuery.of(context).size.width,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                    ),
                                    Positioned(
                                      right: 8,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor: Colors.white.withOpacity(0.5),
                                            elevation: 0,
                                            minimumSize: const Size(50, 30), //height
                                            maximumSize: const Size(60, 30), //width
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                          ),
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.visibility,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "${blogController.astrologySearchBlogs[index].viewer}",
                                                  style: const TextStyle(fontSize: 12, color: Colors.black),
                                                ),
                                              )
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        blogController.astrologySearchBlogs[index].title,
                                        style: Theme.of(context).primaryTextTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ).translate(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              blogController.astrologySearchBlogs[index].author,
                                              style: Theme.of(context).primaryTextTheme.subtitle2,
                                            ).translate(),
                                            Text(
                                              DateFormat("MMM d,yyyy").format(DateTime.parse(blogController.astrologySearchBlogs[index].createdAt)),
                                              style: Theme.of(context).primaryTextTheme.subtitle2,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          blogController.isMoreDataAvailableForSearch == true && !blogController.isAllDataLoadedForSearch && blogController.astrologySearchBlogs.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  });
        }),
      ),
    );
  }
}
