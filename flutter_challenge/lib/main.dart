import 'package:flutter/material.dart';
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
                  child: WelcomeScreen(appState))
              ),
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
