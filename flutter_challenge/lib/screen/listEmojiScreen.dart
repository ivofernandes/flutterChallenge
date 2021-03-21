import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListEmojiScreen extends StatelessWidget{
  AppStateProvider appState;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  ListEmojiScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    Widget listEmoji = renderListEmoji(context);
    return this.appState.getEmoji().isNotEmpty ?
            listEmoji : CircularProgressIndicator();
  }

  Widget renderListEmoji(BuildContext context) {
    List<String> emoji = this.appState.getEmoji();
    GridView grid = GridView.builder(
      itemCount: emoji.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 5
      ),
      itemBuilder: (BuildContext context, int index){
        return GestureDetector(
            child: Image.network(emoji[index]),
            onTap: () {
              emoji.removeAt(index);
              appState.refresh();
            },
        );
      },
    );


    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: () => _onRefresh(context),
      child: grid,
    );
  }

  void _onRefresh(BuildContext context) async{
    await this.appState.loadEmojiPreferences(null, context);
    this.appState.refresh();
    _refreshController.refreshCompleted();
  }

}