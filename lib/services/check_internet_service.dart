import 'package:connectivity_plus/connectivity_plus.dart';

abstract class CheckInternetService {
  static Future<bool> hasInternetConnection() async {
    ConnectivityResult connectivityResult =
    await Connectivity().checkConnectivity();

    return connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile;
  }
}
