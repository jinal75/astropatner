import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/KundliMatching/place_of_birth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class KundliBornPlaceWidget extends StatelessWidget {
  final KundliController kundliController;
  final void Function()? onPressed;
  const KundliBornPlaceWidget({Key? key, required this.kundliController, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => PlaceOfBirthSearchScreen());
            },
            child: IgnorePointer(
              child: FutureBuilder(
                  future: global.translatedText("Birth Place"),
                  builder: (context, snapshot) {
                    return TextField(
                      cursorColor: const Color(0xFF757575),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      controller: kundliController.birthKundliPlaceController,
                      onChanged: (_) {},
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.search),
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintText: snapshot.data ?? 'Birth Place',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                    );
                  }),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.grey)),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Submit',
              textAlign: TextAlign.center,
              style: Get.theme.primaryTextTheme.subtitle1,
            ).translate(),
          ),
        ),
      ],
    );
  }
}
