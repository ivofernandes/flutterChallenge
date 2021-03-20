import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';

class ListEmojiScreen extends StatelessWidget{
  AppStateProvider appState;

  ListEmojiScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    Widget listEmoji = renderListEmoji();
    return this.appState.getEmoji().isNotEmpty ?
            listEmoji : CircularProgressIndicator();
  }

  Widget renderListEmoji() {
    List<String> emoji = this.appState.getEmoji();
    return GridView.builder(
      itemCount: emoji.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
      ),
      itemBuilder: (BuildContext context, int index){
        return Image.network(emoji[index]);
      },
    );
  }

}