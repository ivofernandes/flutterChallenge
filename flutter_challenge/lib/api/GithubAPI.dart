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

    http.Response response = await http.get(url).timeout(Duration(seconds: TIMEOUT),
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

}