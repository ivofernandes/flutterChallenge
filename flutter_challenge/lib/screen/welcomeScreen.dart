import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';

class WelcomeScreen extends StatelessWidget{
  AppStateProvider appState;

  WelcomeScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    Widget bigPicture = renderWelcome();
    return SingleChildScrollView(
        child: Column(
          children: [
            this.appState.getEmoji().isNotEmpty ?
            bigPicture : CircularProgressIndicator()
          ],
        )
    );
  }

  Widget renderWelcome() {
    //TODO use dataframe to parse and show metrics
    return Text(this.appState.getEmoji().toString());
  }

}