import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';

class WelcomeScreen extends StatelessWidget{
  AppStateProvider appState;

  WelcomeScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    Widget welcomeScreen = renderWelcome(context);
    return SingleChildScrollView(
        child: Column(
          children: [
            this.appState.getEmoji().isNotEmpty ?
            welcomeScreen : CircularProgressIndicator()
          ],
        )
    );
  }

  Widget renderWelcome(BuildContext context) {
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
          onPressed: (){
            this.appState.goToEmojiListScreen(context);
            this.appState.refresh();
          },
          child: Text('Emoji List')),
      userSearch(context),
      TextButton(
          onPressed: (){
            this.appState.goToAvatarListScreen(context);
            this.appState.refresh();
            },
          child: Text('Avatar List')),
    ]);
  }

  Widget userSearch(BuildContext context) {
    String username = '';
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () => appState.clearUser()
        ),
        Flexible(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Github username'
              ),
              autocorrect: true,
              onSubmitted: (String searchedWord) {
                this.appState.setUser(username, context);
              },
              onChanged: (String text) {
                username = text.trim().toLowerCase();
              },
              controller: TextEditingController(
                  text: this.appState.getUser()
              ),
            )
        ),
        SizedBox(width: 10),
        GestureDetector(
            onTap: () => this.appState.setUser(username, context),
            child:  Icon(Icons.search)
        )


      ]),
    );
  }

}