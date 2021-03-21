import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListAvatarScreen extends StatelessWidget{
  AppStateProvider appState;

  ListAvatarScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    Widget listEmoji = renderListEmoji(context);
    return this.appState.getAvatarsList().isNotEmpty ?
            listEmoji : Text('No avatars added yet');
  }

  Widget renderListEmoji(BuildContext context) {
    List<String> avatarsList = this.appState.getAvatarsList();
    GridView grid = GridView.builder(
      itemCount: avatarsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        crossAxisSpacing: 5
      ),
      itemBuilder: (BuildContext context, int index){
        return GestureDetector(
            child: Image.network(avatarsList[index]),
            onTap: () {
              appState.removeAvatar(index, context);
            },
        );
      },
    );


    return grid;
  }
}