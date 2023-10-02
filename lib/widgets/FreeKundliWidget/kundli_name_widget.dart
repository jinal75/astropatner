import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/widgets/common_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

// ignore: must_be_immutable
class KundliNameWidget extends StatelessWidget {
  final KundliController kundliController;
  final void Function()? onPressed;
  List<TextInputFormatter>? inputFormatters;
  KundliNameWidget({Key? key, required this.kundliController, required this.onPressed, this.inputFormatters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonTextFieldWidget(
          hintText: "User Name",
          textEditingController: kundliController.userNameController,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
          ),
          onFieldSubmitted: (f) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (text) {
            kundliController.updateIsDisable();

            kundliController.getName(text);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              backgroundColor: MaterialStateProperty.all(kundliController.userNameController.text.isEmpty ? const Color.fromARGB(255, 209, 204, 204) : Get.theme.primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: kundliController.isDisable ? Colors.transparent : Colors.grey)),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Next',
              textAlign: TextAlign.center,
              style: Get.theme.primaryTextTheme.subtitle1!.copyWith(color: kundliController.isDisable ? const Color.fromARGB(255, 100, 98, 98) : null),
            ).translate(),
          ),
        ),
      ],
    );
  }
}
