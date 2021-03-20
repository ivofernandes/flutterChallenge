import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';

class WelcomeScreen extends StatelessWidget{
  AppStateProvider appState;

  WelcomeScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    Widget welcomeScreen = renderWelcome();
    return SingleChildScrollView(
        child: Column(
          children: [
            this.appState.getEmoji().isNotEmpty ?
            welcomeScreen : CircularProgressIndicator()
          ],
        )
    );
  }

  Widget renderWelcome() {
    String randomEmoji = this.appState.getRandomEmoji();
    return Column(children: [
      randomEmoji != null ?
      Container(
          height:64,
          child: Image.network(randomEmoji,)
      )
      : CircularProgressIndicator(),
      TextButton(
          onPressed: ()=> this.appState.newRandomImage(),
          child: Text('Random Emoji')),
      TextButton(
          onPressed: ()=> this.appState.goToEmojiListScreen(),
          child: Text('Emoji List'))
    ]);
  }

}