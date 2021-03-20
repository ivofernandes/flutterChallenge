import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_challenge/api/GithubAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
  final CACHE_EMOJI = 'cache_emoji';

  String _connectionStatus = 'Unknown';
  String _error = null;
  final Connectivity _connectivity = Connectivity();

  List<String>_emojiList = [];

  AppStateProvider(BuildContext context){
    loadPreferences(context);
  }

  Future<void> loadPreferences(BuildContext context) async {
    await initConnectivity();

    var prefs = await SharedPreferences.getInstance();

    // Save the version as it may be useful later to update
    this._emojiList = prefs.getStringList(CACHE_EMOJI);
    if(this._emojiList == null) {
      if (hasInternetConnection()) {
        this._emojiList = await GithubAPI.getEmoji();
      } else {
        _error = 'Check internet connection';
      }
    }

    this.notifyListeners();
  }

  List<String> getEmoji() {
    return this._emojiList;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await (Connectivity().checkConnectivity());
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        break;
    }
  }


  bool hasInternetConnection() {
    if(_connectionStatus == ConnectivityResult.wifi.toString() || _connectionStatus == ConnectivityResult.mobile.toString()){
      return true;
    }
    else{
      return false;
    }
  }

  void refresh() {
    notifyListeners();
  }

  Future<bool> back() {
    print('back pressed');
  }


}
