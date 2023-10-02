import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/HomeController/astrology_blog_controller.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/widgets/common_padding_2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:video_player/video_player.dart';

class AstrologyBlogDetailScreen extends StatelessWidget {
  final String image;
  final String description;
  final String title;
  final String extension;
  final VideoPlayerController videoPlayerController;
  const AstrologyBlogDetailScreen({Key? key, required this.extension, required this.videoPlayerController, required this.title, required this.description, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title: const Text("Astrology Blog").translate(),
        ),
        body: SingleChildScrollView(
          child: CommonPadding2(
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black),
                ).translate(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: image == ""
                        ? Image.asset(
                            "assets/images/2022Image.jpg",
                            height: 230,
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                          )
                        : extension == "mp4" || extension == 'gif'
                            ? GetBuilder<AstrologyBlogController>(builder: (astrologyBlogController) {
                                return Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: SizedBox(
                                            height: 230,
                                            width: Get.width,
                                            child: VideoPlayer(videoPlayerController),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            astrologyBlogController.blogplayPauseVideo(videoPlayerController);
                                          },
                                          child: Icon(
                                            videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    VideoProgressIndicator(
                                      videoPlayerController,
                                      allowScrubbing: true,
                                      colors: const VideoProgressColors(backgroundColor: Colors.grey, playedColor: Colors.red),
                                    )
                                  ],
                                );
                              })
                            : CachedNetworkImage(
                                imageUrl: '${global.imgBaseurl}$image',
                                imageBuilder: (context, imageProvider) => Image.network(
                                  '${global.imgBaseurl}$image',
                                  height: 230,
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/2022Image.jpg",
                                  height: 230,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                              ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                  child: FutureBuilder(
                      future: global.translatedText(description),
                      builder: (context, snapshot) {
                        return Html(
                          data: snapshot.data ?? description,
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
