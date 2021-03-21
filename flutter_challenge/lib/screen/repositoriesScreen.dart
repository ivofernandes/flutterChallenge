import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/state/AppStateProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RepositoriesScreen extends StatelessWidget {
  AppStateProvider appState;

  final ScrollController _scrollController = ScrollController();

  RepositoriesScreen(this.appState);

  @override
  Widget build(BuildContext context) {
    final Future<List<String>> _calculation = appState.getRepositories(context);

    _scrollController.addListener((){
      var remaining = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
      if(remaining < 1500){
        appState.nextRepositories(context);
      }
    });

    return FutureBuilder<List<String>>(
      future: _calculation, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          List<String> repositories = snapshot.data;

          return ListView.builder(
            controller: _scrollController,
            itemCount: repositories.length,
            itemBuilder: (BuildContext context, int index) {
              // Get the second page by default
              if(index == repositories.length -1 && repositories.length == 30){
                appState.nextRepositories(context);
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(repositories[index]),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Column(children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ]);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
