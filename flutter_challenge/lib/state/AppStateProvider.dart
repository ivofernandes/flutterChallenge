import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_challenge/api/GithubAPI.dart';
import 'package:flutter_challenge/state/connectivityState.dart';
import 'package:flutter_challenge/state/navigationState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier, NavigationState, ConnectivityState {

  static const  String CACHE_EMOJI = 'cache_emoji';
  static const  String CACHE_AVATARS = 'cache_avatars';
  static const  String CACHE_USERNAMES_AVATARS = 'cache_usernames_avatars';
  static const  String CACHE_REPOSITORY = 'cache_repository_google';
  static const  String CACHE_REPOSITORY_PAGE = 'cache_repository_page_google';

  Random _random = Random();

  // Emojis
  List<String>_emojiList = [];
  String _randomEmoji;

  // Usernames
  String _username;
  List<String>_avatarsList = [];
  List<String>_usernamesWithAvatars = [];

  // Repository data
  int _currentRepositoryPage = 0;
  List<String> _currentRepositories = [];

  // Semaphore to just do a single next request
  bool _gettingNextRepository = false;

  AppStateProvider(BuildContext context){
    loadPreferences(context);
  }

  ////////////////////////// PREFERENCES /////////////////////////////////////
  Future<void> loadPreferences(BuildContext context) async {
    await initConnectivity();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await loadEmojiPreferences(prefs, context);
    await loadAvatarsPreferences(prefs, context);

  }

  void loadEmojiPreferences(SharedPreferences prefs, BuildContext context) async{
    // Ensure that we have a shared preferences inited
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }

    // Try to get the emoji list from local storage
    this._emojiList = prefs.getStringList(CACHE_EMOJI);

    // If doesn't exist in local storage go for the api
    if(this._emojiList == null) {
      if (hasInternetConnection()) {
        this._emojiList = await GithubAPI.getEmoji();
        prefs.setStringList(CACHE_EMOJI, this._emojiList);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Check internet connection'),
        ));
      }
    }

    this.newRandomImage();
    this.notifyListeners();
  }

  void loadAvatarsPreferences(SharedPreferences prefs, BuildContext context) {
    this._avatarsList = prefs.getStringList(CACHE_AVATARS);
    this._usernamesWithAvatars = prefs.getStringList(CACHE_USERNAMES_AVATARS);

    // Just ensure that it's a list
    if(this._avatarsList == null){
      this._avatarsList = [];
    }
    if(this._usernamesWithAvatars == null){
      this._usernamesWithAvatars = [];
    }
  }

  Future<List<String>> loadRepositories(SharedPreferences prefs, BuildContext context) async{

    // Ensure that we have a shared preferences inited
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }

    this._currentRepositoryPage = prefs.getInt(CACHE_REPOSITORY_PAGE);
    if(this._currentRepositoryPage == null){
      this._currentRepositoryPage = 0;
    }
    // Repositories
    return prefs.getStringList(CACHE_REPOSITORY);
  }

  Future<void> saveRepositories(List<String> repositories, int currentPage,
      SharedPreferences prefs, BuildContext context) async{

    // Ensure that we have a shared preferences inited
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }

    // Repositories
    prefs.setStringList(CACHE_REPOSITORY, repositories);
    prefs.setInt(CACHE_REPOSITORY_PAGE, currentPage);
  }

  Future<void> saveAvatarsList(SharedPreferences prefs, BuildContext context) async{
    // Ensure that we have a shared preferences inited
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }

    // Save the list
    prefs.setStringList(CACHE_AVATARS, this._avatarsList);
    prefs.setStringList(CACHE_USERNAMES_AVATARS, this._usernamesWithAvatars);
  }

  void refresh() {
    notifyListeners();
  }

  ////////////////////////// STORE ACTIONS /////////////////////////////////////
  List<String> getEmoji() {
    return this._emojiList;
  }

  String getRandomEmoji() {
    return this._randomEmoji;
  }

  void newRandomImage() {
    if(this._emojiList != null && this._emojiList.isNotEmpty){
      int index = _random.nextInt(this._emojiList.length);
      this._randomEmoji = this._emojiList[index];
    }
    this.notifyListeners();
  }

  void setUser(String username,BuildContext context) async{
    this._username = username.trim();

    if(!this._usernamesWithAvatars.contains(_username)){
      String avatar = await GithubAPI.getAvatarForUser(username);

      if(avatar != null) {
        // Save the lists
        this._usernamesWithAvatars.add(username);
        this._avatarsList.add(avatar);
        saveAvatarsList(null, context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Avatar added'),
        ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not found'),
        ));
      }
    }
  }

  getUser() {
    return this._username;
  }
  
  void clearUser() {
    this._username = '';
    this.notifyListeners();
  }

  getAvatarsList() {
    return this._avatarsList;
  }

  void removeAvatar(int index, context) async{
    this._usernamesWithAvatars.removeAt(index);
    this._avatarsList.removeAt(index);
    await saveAvatarsList(null, context);
    this.notifyListeners();
  }

  Future<List<String>> getRepositories(BuildContext context) async{

    List<String> repositories = await loadRepositories(null, context);

    if(repositories != null) {
      _currentRepositories = repositories;
      return repositories;
    }else{
      _currentRepositoryPage++;
      repositories = await GithubAPI.getRepos('google', _currentRepositoryPage);
      saveRepositories(repositories, _currentRepositoryPage, null, context);
      _currentRepositories = repositories;
      return repositories;
    }
  }

  void nextRepositories(BuildContext context) async{
    if(this._currentRepositoryPage != -1 && !_gettingNextRepository){
      _gettingNextRepository = true;

      this._currentRepositoryPage++;
      List<String>repositories =
        await GithubAPI.getRepos('google', this._currentRepositoryPage);
      if(repositories != null){
        if(repositories.isNotEmpty) {
          _currentRepositories.addAll(repositories);
          saveRepositories(_currentRepositories, this._currentRepositoryPage, null, context);
          this.notifyListeners();
        }else{
          this._currentRepositoryPage = -1;
          saveRepositories(_currentRepositories, this._currentRepositoryPage, null, context);
        }
        _gettingNextRepository = false;
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Limit of github requests reached, try again later'),
        ));

        Timer _timer = Timer(Duration(seconds: 30), () => _gettingNextRepository = false);
      }
    }
  }

}
