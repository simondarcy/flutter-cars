import 'package:http/http.dart' as http;
import 'dart:convert';

//Simple helper to retrieve data from internet using http package
class NetworkHelper {
  NetworkHelper(this.url);

  final String url;
  Future getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print('Error from server: ${response.statusCode.toString()}');
    }
  }
}
