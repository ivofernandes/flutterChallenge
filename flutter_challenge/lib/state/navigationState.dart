import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';
import 'package:provider/provider.dart';

class NavigationState {
  static const int SCREEN_WELCOME = 0;
  static const int SCREEN_LIST_EMOJI = 1;
  static const int SCREEN_LIST_AVATAR = 2;
  static const int SCREEN_REPOS = 3;

  int _selectedScreen = 0;

  String getScreenTitle(){
    switch(this._selectedScreen){
      case SCREEN_LIST_EMOJI:
        return 'List Emoji';
      case SCREEN_LIST_AVATAR:
        return 'List avatars';
      case SCREEN_REPOS:
        return 'Repositories';
      default:
        return 'Flutter challenge';
    }
  }

  Future<bool> back(BuildContext context) {
    if(this._selectedScreen == SCREEN_WELCOME){
      return Future.value(true);
    }

    this._selectedScreen = SCREEN_WELCOME;
  }

  goToEmojiListScreen(BuildContext context) {
    this._selectedScreen = SCREEN_LIST_EMOJI;
  }

  goToAvatarListScreen(BuildContext context) {
    this._selectedScreen = SCREEN_LIST_AVATAR;
  }

  void goToGoogleReposScreen(BuildContext context) {
    this._selectedScreen = SCREEN_REPOS;
  }

  int getSelectedScreen(){
    return this._selectedScreen;
  }

}