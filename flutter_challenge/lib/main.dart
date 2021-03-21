import 'package:flutter/material.dart';
import 'package:flutter_challenge/screen/listAvatarScreen.dart';
import 'package:flutter_challenge/screen/listEmojiScreen.dart';
import 'package:flutter_challenge/screen/repositoriesScreen.dart';
import 'package:flutter_challenge/screen/welcomeScreen.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';
import 'package:flutter_challenge/state/navigationState.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(FlutterChallengeApp());
}

class FlutterChallengeApp extends StatelessWidget {
  Widget rootScreen(BuildContext context, AppStateProvider appState){
    Future<bool> _onWillPop() async {
      Future<bool> exit =  appState.back(context);
      appState.refresh();
      return exit;
    }

    Widget screen;
    switch(appState.getSelectedScreen()){
      case NavigationState.SCREEN_LIST_EMOJI:
        screen = ListEmojiScreen(appState);
        break;
      case NavigationState.SCREEN_LIST_AVATAR:
        screen = ListAvatarScreen(appState);
        break;
      case NavigationState.SCREEN_REPOS:
        screen = RepositoriesScreen(appState);
        break;
      default:
        screen = WelcomeScreen(appState);
    }
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: "Flutter Challenge App",
        home: Scaffold(
            appBar: AppBar(
              leading: appState.getSelectedScreen() != 0 ?  IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  appState.back(context);
                  appState.refresh();
                },
              ) : null,
              title: Text(appState.getScreenTitle()),
            ),
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: Center(
                  child: screen
              ),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppStateProvider(context),
        child: Consumer<AppStateProvider>(
            builder: (context, appState, child) {
              return rootScreen(context, appState);
            })
    );
  }
}
