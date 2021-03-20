import 'package:flutter/material.dart';
import 'package:flutter_challenge/screen/listEmojiScreen.dart';
import 'package:flutter_challenge/screen/welcomeScreen.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(FlutterChallengeApp());
}

class FlutterChallengeApp extends StatelessWidget {
  Widget rootScreen(BuildContext context, AppStateProvider appState){
    Future<bool> _onWillPop() async {
      return appState.back();
    }

    Widget screen = null;
    switch(appState.getSelectedScreen()){
      case AppStateProvider.SCREEN_LIST_EMOJI:
        screen = ListEmojiScreen(appState);
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
              title: Text('Flutter challenge'),
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
