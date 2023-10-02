import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/HomeController/astrology_blog_controller.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/AstroBlog/astrology_blog_detil_screen.dart';
import 'package:astrologer_app/views/HomeScreen/search_blog_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/widgets/common_padding_2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AstrologyBlogScreen extends StatelessWidget {
  AstrologyBlogScreen({Key? key}) : super(key: key);
  AstrologyBlogController blogController = Get.find<AstrologyBlogController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title: const Text("Astrology Blog").translate(),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => SearchBlogScreen());
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            global.showOnlyLoaderDialog();
            blogController.astrologyBlogs = [];
            blogController.astrologyBlogs.clear();
            blogController.isAllDataLoaded = false;
            blogController.update();
            await blogController.getAstrologyBlog("", false);
            global.hideLoader();
          },
          child: GetBuilder<AstrologyBlogController>(builder: (a) {
            return blogController.astrologyBlogs.isEmpty
                ? Center(
                    child: const Text('Astrology Blogs not available').translate(),
                  )
                : ListView.builder(
                    itemCount: blogController.astrologyBlogs.length,
                    controller: blogController.blogScrollController,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: () async {
                          global.showOnlyLoaderDialog();
                          await blogController.incrementBlogViewer(blogController.astrologyBlogs[index].id);
                          blogController.blogVideo(blogController.astrologyBlogs[index].blogImage);
                          global.hideLoader();
                          Get.to(() => AstrologyBlogDetailScreen(
                                image: blogController.astrologyBlogs[index].blogImage,
                                title: blogController.astrologyBlogs[index].title,
                                description: blogController.astrologyBlogs[index].description ?? "",
                                extension: blogController.astrologyBlogs[index].extension ?? "",
                                videoPlayerController: blogController.videoPlayerController!,
                              ));
                        },
                        child: Column(
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
                                        child: blogController.astrologyBlogs[index].blogImage == ""
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
                                                    imageUrl: '${global.imgBaseurl}${blogController.astrologyBlogs[index].blogImage}',
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
                                      ),
                                      Positioned(
                                        right: 8,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              elevation: 0,
                                              minimumSize: const Size(50, 30), //height
                                              maximumSize: const Size(60, 30), //width
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                              backgroundColor: Colors.white.withOpacity(0.5),
                                              foregroundColor: Colors.black,
                                            ),
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.visibility,
                                                  size: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),
                                                  child: Text(
                                                    "${blogController.astrologyBlogs[index].viewer}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                  CommonPadding2(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          blogController.astrologyBlogs[index].title,
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        ).translate(),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                blogController.astrologyBlogs[index].author,
                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                              ).translate(),
                                              Text(
                                                DateFormat("MMM d,yyyy").format(DateTime.parse(blogController.astrologyBlogs[index].createdAt)),
                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            blogController.isMoreDataAvailable == true && !blogController.isAllDataLoaded && blogController.astrologyBlogs.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    });
          }),
        ),
      ),
    );
  }
}
