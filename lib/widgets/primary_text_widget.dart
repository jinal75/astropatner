import 'package:flutter/material.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class PrimaryTextWidget extends StatelessWidget {
  const PrimaryTextWidget({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: global.translatedText(text ?? ''),
        builder: (context, snapshot) {
          return RichText(
            text: TextSpan(
              text: snapshot.data ?? text,
              style: Theme.of(context).primaryTextTheme.subtitle1,
              children: const <TextSpan>[
                TextSpan(
                  text: "*",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          );
        });
  }
}
