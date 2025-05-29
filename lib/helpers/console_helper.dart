import 'package:flutter/foundation.dart';

 class ConsoleHelper {
  static String _bold = '\x1B[1m';
  static String _italic = '\x1B[3m';

   static void printInfo(String text) => _customDebugPrint('\x1B[34mℹ️Info ---> $text\x1B[0m');
   static void printSuccess(String text) => _customDebugPrint('\x1B[32m☑️Success ---> $text\x1B[0m');
   static void printAlert(String text) => _customDebugPrint('\x1B[33m☢️Alert ---> $text\x1B[0m');
   static void printError(String text) => _customDebugPrint('\x1B[31m🚫   Error ---> $text\x1B[0m');

  static void _customDebugPrint(String text){
    if (kDebugMode) {
      debugPrint(text);
    }
  }
}