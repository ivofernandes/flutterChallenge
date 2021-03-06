import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GithubAPI{

  static int TIMEOUT = 30;
  static String baseUrl = 'https://api.github.com/';

  /// Url example:
  /// https://api.github.com/emojis
  static Future<List<String>> getEmoji() async{

    String url = baseUrl + 'emojis';

    http.Response response = await http.get(url).timeout(
        Duration(seconds: TIMEOUT),
        onTimeout: () {
      throw TimeoutException('Timeout');
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<String> values = List<String>.from(json.values);
      return values;
    }else {
      return [];
    }
  }

  /// https://api.github.com/users/ivofernandes
  static Future<String> getAvatarForUser(String username) async{

    String url = baseUrl + 'users/' + username;

    http.Response response = await http.get(url).timeout(Duration(seconds: TIMEOUT),
        onTimeout: () {
          throw TimeoutException('Timeout');
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if(json.containsKey('avatar_url')){
        return json['avatar_url'];
      }
      return null;
    }else {
      return null;
    }
  }

  ///https://api.github.com/users/google/repos
  static Future<List<String>> getRepos(String username, int currentRepositoryPage) async{

    String url = baseUrl + 'users/' + username + '/repos?page='
        + currentRepositoryPage.toString();

    http.Response response = await http.get(url).timeout(Duration(seconds: TIMEOUT),
        onTimeout: () {
          throw TimeoutException('Timeout');
        });

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      List<String> values = [];

      for(Map<String, dynamic> obj in json){
        if(obj.containsKey('full_name')) {
          values.add(obj['full_name']);
        }
      }

      return values;
    }else {
      return null;
    }
  }
}