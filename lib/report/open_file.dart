// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:astrologer_app/report/open_result.dart';
import 'package:flutter/services.dart';

// import 'macos.dart' as mac;
// import 'windows.dart' as windows;
// import 'linux.dart' as linux;

class OpenFile {
  static const MethodChannel _channel = MethodChannel('open_file');

  OpenFile._();

  ///linuxDesktopName like 'xdg'/'gnome'
  static Future<OpenResult> open(String? filePath, {String? type, String? uti, String linuxDesktopName = "xdg", bool linuxByProcess = false}) async {
    assert(filePath != null);
    if (!Platform.isIOS && !Platform.isAndroid) {
      int? result;
      var windowsResult;
      if (Platform.isMacOS) {
        // _result = mac.system(['open', '$filePath']);
      } else if (Platform.isLinux) {
        if (linuxByProcess) {
          result = Process.runSync('xdg-open', [filePath!]).exitCode;
        } else {
          //   _result = linux.system(['$linuxDesktopName-open', '$filePath']);
        }
      } else if (Platform.isWindows) {
        //  _windowsResult = windows.shellExecute('open', filePath!);
        result = windowsResult <= 32 ? 1 : 0;
      } else {
        result = -1;
      }
      return OpenResult(
          type: result == 0 ? ResultType.done : ResultType.error,
          message: result == 0
              ? "done"
              : result == -1
                  ? "This operating system is not currently supported"
                  : "there are some errors when open $filePath${Platform.isWindows ? "   HINSTANCE=$windowsResult" : ""}");
    }

    Map<String, String?> map = {
      "file_path": filePath!,
      "type": type,
      "uti": uti,
    };
    final result = await _channel.invokeMethod('open_file', map);
    final resultMap = json.decode(result);
    return OpenResult.fromJson(resultMap);
  }
}
